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

    users = data;
});

function hash(data) {
    return require('crypto').createHash('md5').update(data).digest('hex');
}

function saveChanges() {
    fs.writeFile('./data/users.json', users, 'utf8', (err) => { if (err) return console.error(err); console.log('Saved users'); });
    fs.writeFile('./data/codes.json', codes, 'utf8', (err) => { if (err) return console.error(err); console.log('Saved codes'); });
    fs.writeFile('./data/labs.json', labs, 'utf8', (err) => { if (err) return console.error(err); console.log('Saved labs'); });
}

function registerUser(username, password) {
    let id = uuid.v4();
    while (Object.keys(users).includes(id)) {
        id = uuid.v4();
    }

    users[id] = {
        username: username,
        password: hash(password)
    };
    saveChanges();
}

function logIn(username, password) {
    let result = Object.keys(users).filter(key => users[key].username === username);

    if (result.length !== 1) {
        return undefined;
    }

    let key = result[0];

    if (hash(password) === users[key].password) {
        return jwt.sign({
            data: key
        }, 'electrum', { expiresIn: '2h' });
    }
}

app.post('/login', (req, res) => {
    let info = JSON.parse(Object.keys(req.body)[0]);
    console.log(info);

    let token = logIn(info.username, info.password);

    if (token) {
        res.status(200);
        res.send(token);
    } else {
        res.status(401);
        res.end();
    }
})

app.get('/codes', (req, res) => {
    let id;
    jwt.verify(req.header('Authorization').split(' ')[1], 'electrum', function(err, decoded) {
        if (err) {
            res.status(404);
            res.end();
        }
        id = decoded;
    });
    res.send(JSON.stringify(users[id].codes));
});

app.get('/labs', (req, res) => {
    console.log('requested labs');

    if (req.header('Authorization') === 'Bearer jan:4444') {
        console.log('accept');
        res.status(200);
        console.log(labs);
        res.send(JSON.stringify(labs));
    }

});

app.get('/labs/join/:joinID', (req, res) => {
    console.log('join ' + req.params.joinID);

    if (req.header('Authorization') === 'Bearer jan:4444') {
        console.log('accept');
        res.status(200);
        labs.push({
            id: parseInt(req.params.joinID),
            name: 'Lab ' + req.params.joinID,
            owner: 'jan',
            participants: ['User1', 'User2', 'User3', 'User4', 'User5', 'User6', 'User7', 'User8', 'User9', 'User10', 'User11', 'User12'],
            start: new Date(),
            end: new Date()
        });
        res.send(JSON.stringify(labs));
    }

});

app.get('/labs/kick/:labID/:parID', (req, res) => {
    console.log('kick ' + req.params.parID + ' from lab ' + req.params.labID);

    if (req.header('Authorization') === 'Bearer jan:4444') {
        console.log('accept');
        labs.filter(l => l.id === parseInt(req.params.labID))[0].participants.splice(req.params.parID, 1);
        res.status(200);
        res.send(labs.filter(l => l.id === parseInt(req.params.labID))[0]);
    }

});

app.post('/codes', (req, res) => {
    console.log(req.body);
    let code = JSON.parse(Object.keys(req.body)[0]);
    console.log('add', code);

    if (code && code.text && code.code) {
        codes.push(code);
        res.status(204);
        res.end();
    } else {
        res.status(400);
        res.end();
    }
});

app.listen(port, () => {
    console.log('started');
});
