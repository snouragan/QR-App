const express = require('express');
const cors = require('cors');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const uuid = require('uuid');
const app = express();

app.use(cors());
app.use(express.urlencoded({ extended: true }));

const port = 3000;


let labSchedule = {};

let users = {};
let labs = {};

let codes = [];

function readSchedule() {
    fs.readFile('./data/lab_schedule.json', 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            return;
        }
        labSchedule = JSON.parse(data);
    });
}

function readUsers() {
    fs.readFile('./data/users.json', 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            return;
        }
        users = JSON.parse(data);
    });    
}

function readLabs() {
    fs.readFile('./data/labs.json', 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            return;
        }
        labs = JSON.parse(data);
    });
}

function scheduleLabByKey(key) {
    for (let year in labSchedule[key].schedule) {
        if (parseInt(year) < new Date().getFullYear()) {
            continue;
        }
        for (let month in labSchedule[key].schedule[year]) {
            if (parseInt(month) < new Date().getMonth() + 1) {
                continue;
            }
            for (let day in labSchedule[key].schedule[year][month]) {
                if (parseInt(day) < new Date().getDate()) {
                    continue;
                }

                if (labSchedule[key].schedule[year][month][day].length !== 2) {
                    continue;
                }

                let start = labSchedule[key].schedule[year][month][day][0];
                let end = labSchedule[key].schedule[year][month][day][1];


                if (start >= end) {
                    continue;
                }

                let startMillis = new Date(parseInt(year), parseInt(month - 1), parseInt(day), start, 0, 0, 0).getTime();
                let endMillis = new Date(parseInt(year), parseInt(month - 1), parseInt(day), end, 0, 0, 0).getTime();
                
                for (let k in labs) {
                    if (labs[k].name === labSchedule[key].name) {
                        if (new Date(labs[k].start).getTime() === startMillis) {
                            return;
                        }

                        let newLab = {
                            "code": labs[k].code,
                            "name": labs[k].name,
                            "owner": labs[k].owner,
                            "participants": labs[k].participants,
                            "pending": labs[k].pending,
                            "start": startMillis,
                            "end": endMillis,
                        };

                        delete labs[k];
                        labs[uniqueUUID(labs)] = newLab;
                        saveChanges();
                        return;
                    }
                }

                labs[uniqueUUID(labs)] = {
                    "code": labSchedule[key].code,
                    "name": labSchedule[key].name,
                    "owner": labSchedule[key].owner,
                    "participants": labSchedule[key].participants,
                    "pending": labSchedule[key].pending,
                    "start": startMillis,
                    "end": endMillis,
                }
                saveChanges();
            }
        }
    }
}

function scheduleNextLabs() {
    for (let lab in labSchedule) {
        scheduleLabByKey(lab);
    }
}

function generateQR(labID, userID) {
    let res = labID.replaceAll('-', '') + userID.replaceAll('-', '');

    let sum = 0;
    for (let r in res) {
        sum += res.charCodeAt(r);
    }

    return sum*sum;
}

function generateCodes() {

    let codeList = [];

    Object.keys(labs).forEach(key => {
        if (labs[key].start <= new Date().getTime() && labs[key].end >= new Date().getTime()) {
            codeList.push(generateQR(key, labs[key].owner));
            labs[key].participants.forEach(p => {
                codeList.push(generateQR(key, p));
            });
        }
    });

    codes = codeList;
}

function backupData() {

    let h = new Date().getHours();

    if (h % 2 === 1) {
        return;
    }

    fs.writeFile(`./backups/users_${h}.json`, JSON.stringify({date: new Date(), data: users}), 'utf8', (err) => { if (err) return console.error(err); console.log('Backed up users'); });   
    fs.writeFile(`./backups/labs_${h}.json`, JSON.stringify({date: new Date(), data: labs}), 'utf8', (err) => { if (err) return console.error(err); console.log('Backed up labs'); });   
}


function saveChanges() {
    fs.writeFile('./data/users.json', JSON.stringify(users), 'utf8', (err) => { if (err) return console.error(err); console.log('Saved users'); });
    fs.writeFile('./data/labs.json', JSON.stringify(labs), 'utf8', (err) => { if (err) return console.error(err); console.log('Saved labs'); });
}

function hash(data) {
    return require('crypto').createHash('md5').update(data).digest('hex');
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

function beautifyLab(lab, labID, userID) {

    let qr = lab.start <= new Date().getTime() && lab.end >= new Date().getTime() ? generateQR(labID, userID) : -1;

    return {
        "code": lab.code,
        "name": lab.name,
        "owner": users[lab.owner].username,
        "participants": lab.participants.map(p => users[p].username),
        "pending": lab.pending.map(p => users[p].username),
        "start": lab.start,
        "end": lab.end,
        "qr": qr
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

        Object.keys(labs).forEach(key => {
            
            if (labs[key].owner === decoded.data || labs[key].participants.includes(decoded.data)) {
                labsToSend.push(beautifyLab(labs[key], key, decoded.data));
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
        return res.send(JSON.stringify(beautifyLab(labs[labKey], labKey, userKey)));
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
        return res.send(JSON.stringify(beautifyLab(labs[labKey], labKey, userKey)));
    });
});


readSchedule();
readUsers();
readLabs();

scheduleNextLabs();
generateCodes();
setInterval(scheduleNextLabs, 1000 * 60);
setInterval(generateCodes, 1000 * 20);
setInterval(backupData, 1000 * 60 * 60 * 2);

app.listen(port, () => {
    console.log('started');
});
