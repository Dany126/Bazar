const { Resend } = require("resend");

const resend = new Resend(process.env.RESEND_API_KEY);
const sendEmail = async (to, from, subject, html) => {
  const { data, error } = await resend.emails.send({
    to: to,
    from: from,
    subject: subject,
    html: html,
  });
  return {
    data,
    error,
  };
};

module.exports = { sendEmail };
