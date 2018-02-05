const express = require("express")
const app = express()
const mongoose = require('mongoose')

const jwt=require('jsonwebtoken')
const bcrypt = require('bcrypt')

const User = require('./models/user')
const Deck = require('./models/deck')

const http = require('http')
const ws = require('ws').Server

const PORT=process.env.PORT || 443

const server = http.Server(app)

const wss = new ws({
    server: server,
    perMessafeDefalte:false
})



server.listen(PORT,()=>{
    console.log('socket running')
})


mongoose.connect('mongodb://localhost:27017/NotFaeria')


app.use(express.json())
app.use(express.urlencoded({extended:true}))

//SOCKET

var users = []
var connections = []

wss.on('connection', (socket)=>{
    console.log('connected')
    socket.onmessage = event=>console.log(event.data)
    socket.onerror = error=>console.log(error)
})

_on_time = ()=>{
    msg = "A"
    
    wss.clients.forEach(client=>{
        try{
            client.send(msg)
        } catch(err){
            console.log(err)
        }
    })
}

setInterval(_on_time,3000)



function check(req,res,next){
    console.log("body", req.body)
    next()
}

app.get('/decks', authenticate, check,(req,res)=>{
    const user = req.user.username
    Deck.find({username:user}).then(
        decks=>{
            console.log(decks)
            
            const deckNames = decks.map(deck=>{return {deck_name:deck.deck_name,cards:deck.cards}})
            res.status(200).json(deckNames)
        }
    ).catch(
        err=>{
            console.log(err)
            res.status(403).json({message:'could not load decks'})
        }
    )
})

app.get('/decks/:name', authenticate, (req,res)=>{
    
    const user = req.user.username
    Deck.findOne({username:user,deck_name:req.params.name}).then(
        deck=>{
            
            res.status(200).json(deck)
        }
    ).catch(
        err=>{
            console.log(err)
            res.status(403).json({message:'could not load decks'})
        }
    )
    
})

app.put('/decks/:name', authenticate, (req,res)=>{
    const changes = req.body
    const user = req.user.username
    console.log(changes)
    console.log(req.params.name)
    Deck.findOne({username:user,deck_name:req.params.name}).then(
        found=>{
            if (found){
                Object.keys(changes).forEach(prop=>{
                    console.log(prop)
                    
                    found[prop]=changes[prop]
                })
                return found.save()
            } else {
               throw "deck not found"
            }
        }
    ).then(
        result =>{
            res.status(200).json({message:'deck updated successfully'})
        }
    ).catch(err=>{
        console.log(err)
        res.status(501).json({message:'something failed, saving deck'})
    })
})

app.post('/decks/:name', authenticate,(req,res)=>{
    const deckList = req.body.cards
    const user = req.user.username
    console.log('create deck for ', user)
    Deck.findOne({username:user,deck_name:req.params.name}).then(
        found=>{
            if (found){
                found.cards = deckList
                return found.save()
            } else {
                return Deck.create({
                    username:user,
                    deck_name:req.params.name,
                    cards:deckList
                })
            }
        }
    )
    .then(
        ret=>{
            console.log('deck made')
            res.status(200).json({message:'deck create'})
        }
    ).catch(
        err=>{
            console.log(err)
            res.status(403).json({message:'could not save deck'})
        }
    )
})

app.post('/register', (req,res)=>{
    const username = req.body.username
    const password = req.body.password
    register(username,password).then(
        user=>{
            //add jwt
            res.set({authenticate:signJWT({username:user.username,id:user._id})})
            delete user.password
            res.status(200).json(user)
        }
    ).catch(
        err=>{
            console.log(err)
            res.status(401).json({message:'failed to create user'})
        }
    )
})

app.post('/login',(req,res)=>{
    const username = req.body.username
    const password = req.body.password
    verify(username,password).then(
        user=>{
            //add jwt
            res.set({authenticate:signJWT({username:user.username,id:user._id})})
            delete user.password
            res.status(200).json(user)
        }
    ).catch(
        err=>{
            console.log(err)
            res.status(403).json({message:'failed to log in'})
        }
    )
})

app.get('/user/friends', authenticate, (req, res)=>{
    const user = req.user.id
    User.findOne({_id:user}).then(
        user=>{
            res.status(200).json(user.friends)
        }
    ).catch(
        err=>{
            res.status(404).json({message:'could not get friends'})
        }
    )
})

app.post('/user/friends', authenticate, (req,res)=>{
    const user = req.user.id
    const friend = req.body.friend
    User.findOne({username:friend}).then(
        foundUser=>{
            return User.findOne({_id:user}).then(
                user=>{
                    user.friends.push(foundUser.username)
                    return user.save()
                }
            )
        }
    )
    .then(
        savedUser=>{
            res.status(200).json({message:'friend added'})
        }
    )
    .catch(err=>{
        res.status(500).json({message:'friend add failed'})
    })
})


function register(username, password){

    return new Promise((resolve,reject)=>{
        bcrypt.genSalt(12,(err,salt)=>{
            if (err){
                return reject(err)
            }
            bcrypt.hash(password,salt,(err,hash)=>{
                if (err){
                    return reject(err)
                }
                console.log(hash)
                
                User.create({
                    username:username,
                    password:hash,
                }, (err,user)=>{
                    if (err){
                        console.log('hash err')
                        return reject(err)
                    }
                    if (!user){
                        console.log("null user")
                        return reject("failed to make user")
                    }
                    return resolve(user)
                })
            })
        })
    })
}

function verify(username, password){
    return new Promise((resolve,reject)=>{
        User.findOne({'username':username},(err,founduser)=>{
            if (err){
                return reject(err)
            }
            if (!founduser){
                return reject("user not found")
            }
            bcrypt.compare(password,founduser.password,(err,res)=>{
                console.log('res',res)
                if (err){
                    console.log('err',err)
                    return reject(err)
                }
                if (res){
                    return resolve(founduser)
                } else {
                    return reject("password mismatch")
                }
            
            })
        })
    })
}

function authenticate(req,res,next){
    let token = req.headers.authenticate

    verifyJWT(token).then(
        user =>{
            req.user = user.data
            console.log('auth good')
            next()
        }
    ).catch(
        err=>{
            console.log('auth bad')
            res.status(403).json({message:'authentication failed'})
        }
    )
}

function signJWT(obj){
    	let token = jwt.sign(
			{data:obj},
			'secret',
			 {algorithm:'HS256'}
		)
	return token
}


function verifyJWT(token){
	//copied code
	return new Promise ((resolve,reject)=>{
		jwt.verify(token,'secret', (err,tokenDecoded)=>{
			if (err || !tokenDecoded){
				return reject(err);
			}
			resolve(tokenDecoded)
		})
	})
}

/*
app.listen(PORT, ()=>{
    console.log('connected on '+ PORT)
})
*/




