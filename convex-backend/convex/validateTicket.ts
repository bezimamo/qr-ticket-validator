// convex/validateTicket.ts
import { mutation } from "./_generated/server";
import { v } from "convex/values";

export const validateTicket = mutation({
  args: {
    ticketId: v.string(),
    eventId: v.string(),
  },
  handler: async (ctx, { ticketId, eventId }) => {
    // Retrieve the ticket document from Convex DB
    const ticket = await ctx.db.get(ticketId);

    // If the ticket doesn't exist, return invalid format
    if (!ticket) {
      return { status: "invalid_format" };
    }

    // Check if the eventId matches the ticket's eventId
    if (ticket.eventId !== eventId) {
      return { status: "wrong_event" };
    }

    // If the ticket is already used, return "used"
    if (ticket.used) {
      return { status: "used" };
    }

    // Mark the ticket as used and return valid status
    await ctx.db.patch(ticketId, { used: true });

    return { status: "valid" };
  },
});
