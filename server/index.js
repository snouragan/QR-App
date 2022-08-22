const express = require('express');
const cors = require('cors');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const uuid = require('uuid');
const app = express();

app.use(cors());
app.use(express.urlencoded({ extended: true }));

const port = 3000;

let users = {};
let labs = {};

fs.readFile('./data/users.json', 'utf8', (err, data) => {
    if (err) {
        console.error(err);
        return;
    }
    users = JSON.parse(data);
});

fs.readFile('./data/labs.json', 'utf8', (err, data) => {
    if (err) {
        console.error(err);
        return;
    }
    labs = JSON.parse(data);
});

function hash(data) {
    return require('crypto').createHash('md5').update(data).digest('hex');
}

function saveChanges() {
    fs.writeFile('./data/users.json', JSON.stringify(users), 'utf8', (err) => { if (err) return console.error(err); console.log('Saved users'); });
    fs.writeFile('./data/labs.json', JSON.stringify(labs), 'utf8', (err) => { if (err) return console.error(err); console.log('Saved labs'); });
}

function getUserIDByUsername(username) {
    let result = Object.keys(users).filter(key => users[key].username === username);
    if (result.length !== 1) {
        return undefined;
    }
    return result[0];
}

function getLabIDByCode(code) {
    let result = Object.keys(labs).filter(key => labs[key].code === code);
    if (result.length !== 1) {
        return undefined;
    }
    return result[0];
}

function beautifyLab(lab) {
    return {
        "code": lab.code,
        "name": lab.name,
        "owner": users[lab.owner].username,
        "participants": lab.participants.map(p => users[p].username),
        "pending": lab.pending.map(p => users[p].username),
        "start": lab.start,
        "end": lab.end
    }
}

function uniqueUUID(collection) {
    let id = uuid.v4();
    while (Object.keys(collection).includes(id)) {
        id = uuid.v4();
    }
    return id;
}

function registerUser(username, password) {
    if (getUserIDByUsername(username)) {
        return false;
    }

    users[uniqueUUID(users)] = {
        username: username,
        password: hash(password),
        codes: []
    };
    saveChanges();
    return true;
}

function logIn(username, password) {
    let key = getUserIDByUsername(username);

    if (!key) {
        return undefined;
    }

    if (hash(password) === users[key].password) {
        return jwt.sign({
            data: key
        }, 'electrum', { expiresIn: '2h' });
    }
}

app.post('/register', (req, res) => {
    
    if (req.body && req.body.username && req.body.password && registerUser(req.body.username, req.body.password)) {
        res.status(200);
        return res.end();
    }
    res.status(400);
    return res.end();
});

app.post('/login', (req, res) => {
    
    if (!req.body || !req.body.username || !req.body.password) {
        console.error('Invalid request');
        res.status(401);
        return res.end();
    }

    let token = logIn(req.body.username, req.body.password);
    if (token) {
        res.status(200);
        return res.send(token);
    } else {
        res.status(401);
        return res.end();
    }
});

app.get('/labs', (req, res) => {
    
    jwt.verify(req.header('Authorization').split(' ')[1], 'electrum', function(err, decoded) {
        
        if (err) {
            console.error(err);
            res.status(401);
            return res.end();
        }
    
        let labsToSend = [];

        Object.values(labs).forEach(lab => {
            
            if (lab.owner === decoded.data || lab.participants.includes(decoded.data)) {
                labsToSend.push(beautifyLab(lab));
            }
        });

        res.status(200);
        return res.send(JSON.stringify(labsToSend));
    });
});

app.get('/labs/join/:joinID', (req, res) => {
    
    if (!req.params || !req.params.joinID) {
        console.error('Invalid request');
        res.status(401);
        return res.end();
    }

    jwt.verify(req.header('Authorization').split(' ')[1], 'electrum', function(err, decoded) {
        
        if (err) {
            console.error(err);
            res.status(401);
            return res.end();
        }

        let labKey = getLabIDByCode(req.params.joinID);

        if (!labKey) {
            console.error(`Cannot find lab with join code ${req.params.joinID}`);
            res.status(400);
            return res.end();
        }

        if (labs[labKey].participants.includes(decoded.data) || labs[labKey].pending.includes(decoded.data)) {
            console.error(`User ${decoded.data} already joined this lab`);
            res.status(400);
            return res.end();
        }

        labs[labKey].pending.push(decoded.data);
        saveChanges();
        res.status(200);
        return res.send(JSON.stringify(labs));
    });
});

app.get('/labs/pending/:labID/:parID/:accept', (req, res) => {

    if (!req.params || !req.params.labID || !req.params.parID || !req.params.accept) {
        console.error('Invalid request');
        res.status(401);
        return res.end();
    }

    jwt.verify(req.header('Authorization').split(' ')[1], 'electrum', function(err, decoded) {
        if (err) {
            console.error(err);
            res.status(401);
            return res.end();
        }
    
        let labKey = getLabIDByCode(req.params.labID);

        if (labs[labKey].owner !== decoded.data) {
            console.error(`User ${decoded.data} does not own the specified lab`);
            res.status(401);
            return res.end();
        }

        let userKey = getUserIDByUsername(req.params.parID);

        if (!labs[labKey].pending.includes(userKey)) {
            console.error(`User ${req.params.parID} is not a participant of lab ${labKey}`);
            res.status(401);
            return res.end();
        }

        labs[labKey].pending = labs[labKey].pending.filter(p => p !== userKey);

        if (req.params.accept === '1') {
            labs[labKey].participants.push(userKey);
        }

        saveChanges();
        res.status(200);
        return res.send(JSON.stringify(beautifyLab(labs[labKey])));
    });
});

app.get('/labs/kick/:labID/:parID', (req, res) => {
    
    if (!req.params || !req.params.labID || !req.params.parID) {
        console.error('Invalid request');
        res.status(401);
        return res.end();
    }

    jwt.verify(req.header('Authorization').split(' ')[1], 'electrum', function(err, decoded) {
        if (err) {
            console.error(err);
            res.status(401);
            return res.end();
        }
    
        let labKey = getLabIDByCode(req.params.labID);

        if (labs[labKey].owner !== decoded.data) {
            console.error(`User ${decoded.data} does not own the specified lab`);
            res.status(401);
            return res.end();
        }

        let userKey = getUserIDByUsername(req.params.parID);

        if (!labs[labKey].participants.includes(userKey)) {
            console.error(`User ${req.params.parID} is not a participant of lab ${labKey}`);
            res.status(401);
            return res.end();
        }

        labs[labKey].participants = labs[labKey].participants.filter(p => p !== userKey);
        saveChanges();
        res.status(200);
        return res.send(JSON.stringify(beautifyLab(labs[labKey])));
    });
});

app.listen(port, () => {
    console.log('started');
});
