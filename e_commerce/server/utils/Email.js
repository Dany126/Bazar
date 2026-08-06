import { Resend } from "resend";
import dotenv from "dotenv";
dotenv.config({ path: "./.env" });

const resend = new Resend(process.env.RESEND_API_KEY);
export const sendEmail = async (to, from, subject, html) => {
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
