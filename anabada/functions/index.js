const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;

const mailTransport = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

exports.sendUserIdEmail = functions.https.onCall((data, context) => {
  const email = data.email;
  const userId = data.userId;

  const mailOptions = {
    from: gmailEmail,
    to: email,
    subject: "Your User ID",
    text: `Your User ID is: ${userId}`,
  };

  return mailTransport.sendMail(mailOptions)
      .then(() => {
        return {success: true};
      })
      .catch((error) => {
        console.error("There was an error while sending the email:", error);
        throw new functions.https.HttpsError("unknown", "Failed to send email");
      });
});
