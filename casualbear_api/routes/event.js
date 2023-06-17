const { Event } = require("../app/models");
const router = require("express").Router();
const path = require("path");
const AWS = require("aws-sdk");

// Configure AWS credentials
AWS.config.update({
  accessKeyId: "AKIAYTNOFOJOVWK54WQG",
  secretAccessKey: "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",
  region: "us-east-1",
});

function uploadImageToS3(filePath, bucketName, objectKey) {
  // Read the image file
  const fs = require("fs");
  const fileContent = fs.readFileSync(filePath);

  // Set S3 parameters
  const params = {
    Bucket: bucketName,
    Key: objectKey,
    Body: fileContent,
  };

  // Upload the image file to S3
  return new Promise((resolve, reject) => {
    s3.upload(params, (err, data) => {
      if (err) {
        reject(err);
      } else {
        resolve(data.Location);
      }
    });
  });
}

// Create an S3 client instance
const s3 = new AWS.S3();

// Define the route for uploading the event
router.post("/createFile", async (req, res) => {
  try {
    const filePath = "uploads/iconFile-1686761710103-749294256";
    const bucketName = "casualbearapi-staging";
    const objectKey = "stuff.jpg";

    uploadImageToS3(filePath, bucketName, objectKey)
      .then((s3Url) => {
        console.log("Image uploaded successfully!");
        console.log("S3 URL:", s3Url);
        res.status(201).json({ url: s3Url });
      })
      .catch((err) => {
        console.error("Error uploading image:", err);
        res.status(500).json({ error: err });
      });
  } catch (error) {
    console.error("Error creating event:", error);
    res.status(500).json({ error: error });
  }
});

// Define the route for uploading the event
router.post("/upload-event", async (req, res) => {
  try {
    // Create a new event in the database
    const event = await Event.create({
      name: req.body.name,
      description: req.body.description,
      selectedColor: req.body.selectedColor,
      rawUrl: req.body.rawUrl,
    });

    res.status(201).json(event);
  } catch (error) {
    console.error("Error creating event:", error);
    res.status(500).json({ error: error });
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
