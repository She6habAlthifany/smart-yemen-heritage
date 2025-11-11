const express = require('express');
const router = express.Router();
const ContentDetails = require('../models/ContentDetails');

router.post('/', async (req, res) => { try { const item = await ContentDetails.create(req.body); res.status(201).json(item); } catch (err) { res.status(400).json({ message: err.message }); } });
router.get('/by-content/:contentId', async (req, res) => { try { const list = await ContentDetails.find({ content_id: req.params.contentId }); res.json(list); } catch (err) { res.status(500).json({ message: err.message }); } });

module.exports = router;
