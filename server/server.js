const express = require("express")
const WebSocket=require("ws")
const http=require("http")
const app=express()

const PORT=8080

const server= http.createServer(app)
const wss=new WebSocket.Server({server})

const games={}

function joinGame(games,getId){
	console.log("outer Run")
	return function(ws,req){
		let id=getId(games)
		console.log("inner run")
		games[id].push(ws)
		ws.on("message",(message)=>{
			//will need to verify message with game server logic
			games[id].forEach(con=>{
				con.send(message)
			})

			ws.send("connected")
		})
	}
}

function getId(games){
	//check for open game
	//TODO eventually make separate arrays for open games?
	for (game in games){
		if (games[game].length<2){
			return game
		}
	}
	//TODO make this deterministic not random, large hash
	let rand = Math.floor(Math.random()*100000)
	while (Object.keys(games).includes(rand)){
		rand = Math.floor(Math.random()*100000)
	}
	games[rand]=[]
	return rand
	
}

wss.on("connection", joinGame(games,getId))

server.listen(PORT, ()=>{
	console.log("server started")
})
