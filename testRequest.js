import { ConvexHttpClient } from "convex/browser";

const convex = new ConvexHttpClient("https://doting-cow-746.convex.cloud"); 

async function validateTicket() {
  try {
    const result = await convex.mutation("validateTicket", {
      ticketId: "123",
      eventId: "event123",
    });

    console.log("Server response:", result);
  } catch (error) {
    console.error("Error making API request:", error);
  }
}

validateTicket();
