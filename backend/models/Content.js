const mongoose = require('mongoose');

const ContentSchema = new mongoose.Schema({
  address: { type: String },
  lat: { type: String },
  type_id: { type: mongoose.Schema.Types.ObjectId, ref: 'ContentType' },
  admin_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Admin' },
}, { timestamps: true });
module.exports = mongoose.model('Content', ContentSchema);
