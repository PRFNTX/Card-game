const mongoose = require('mongoose')

const deckSchema = new mongoose.Schema({
    username:String,
    name:String,
    cards:[Number]
})

module.exports = mongoose.model('deck',deckSchema)
