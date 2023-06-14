const { Event } = require("../app/models");
const multer = require("multer");
const router = require("express").Router();
const path = require("path");

// Set up Multer for handling file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "./uploads/"); // Set the destination folder for uploaded files
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    const fileName = file.fieldname + "-" + uniqueSuffix; // Set the filename for the uploaded file
    const fullPath = path.join(__dirname, "..", "uploads", fileName); // Get the full path by joining the parent directory and the file name
    cb(null, fileName);
    console.log("Full Path:", fullPath);
    req.fullPath = fullPath; // Store the full path in the request object
  },
});

const upload = multer({ storage });

// Define the route for uploading the event
router.post("/upload-event", upload.single("iconFile"), async (req, res) => {
  try {
    // Create a new event in the database
    const event = await Event.create({
      name: req.body.name,
      description: req.body.description,
      selectedColor: req.body.selectedColor,
      iconFile: req.fullPath, // Store the filename in the database
    });

    res.status(201).json(event);
  } catch (error) {
    console.error("Error creating event:", error);
    res.status(500).json({ error: "Failed to create event" });
  }
});

router.get("/events", async (req, res) => {
  try {
    // Retrieve all events from the database
    const events = await Event.findAll();

    res.status(200).json({ events });
  } catch (error) {
    console.error("Error retrieving events:", error);
    res.status(500).json({ error: "Failed to retrieve events" });
  }
});

// GET method to fetch event data
router.get("/events/:eventId", async (req, res) => {
  try {
    const eventId = req.params.eventId;

    // Find the event by its ID in the database
    const event = await Event.findByPk(eventId);

    if (!event) {
      return res.status(404).json({ error: "Event not found." });
    }

    // Send the event as the response
    res.json({ event });
  } catch (error) {
    // Handle any errors that occurred during event retrieval
    console.error("Error retrieving event:", error);
    res
      .status(500)
      .json({ error: "An error occurred while retrieving the event." });
  }
});

module.exports = router;
