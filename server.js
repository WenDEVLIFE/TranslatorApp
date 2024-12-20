const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

// Initialize Express app
const app = express();

// Middleware
app.use(bodyParser.json());

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/MobileTransApp', { 
  useNewUrlParser: true, 
  useUnifiedTopology: true 
})
.then(() => console.log('MongoDB connected...'))
.catch(err => console.error('MongoDB connection error:', err));

// Create a Schema and Model
const TranslationSchema = new mongoose.Schema({
  sourceText: { type: String, required: true },
  translatedText: { type: String, required: true },
  sourceLanguage: { type: String, required: true },
  targetLanguage: { type: String, required: true }
});

const Translation = mongoose.model('Translation', TranslationSchema);

// Create Express Routes
app.post('/translate', async (req, res) => {
  const { sourceText, translatedText, sourceLanguage, targetLanguage } = req.body;

  const translation = new Translation({
    sourceText,
    translatedText,
    sourceLanguage,
    targetLanguage
  });

  try {
    const savedTranslation = await translation.save();
    res.status(201).json(savedTranslation); // 201 Created
  } catch (err) {
    console.error('Error saving translation:', err);
    res.status(500).send('Error saving translation.');
  }
});

app.get('/', (req, res) => {
  res.send('Translation API is working!');
});

// Start the server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
