/**
 * Brighter Days — Gmail → Supabase reply sync
 *
 * HOW IT WORKS:
 * 1. Fetches all vendors from Supabase that still have status "Sent"
 * 2. For each vendor, searches Gmail for threads where YOU sent to their email
 * 3. If anyone in that thread replied (not just the original address —
 *    could be a different person at the same company), it grabs the reply
 * 4. Updates Supabase with the reply snippet, date, and who replied
 *
 * SETUP:
 * 1. Go to script.google.com → New Project
 * 2. Paste this entire file
 * 3. Click Run → checkVendorReplies() once to authorize Gmail access
 * 4. Go to Triggers (clock icon) → Add Trigger:
 *    - Function: checkVendorReplies
 *    - Event source: Time-driven
 *    - Type: Minutes timer → Every 15 minutes
 */

const SUPABASE_URL = 'https://ymejmufmaivocbwpadiy.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InltZWptdWZtYWl2b2Nid3BhZGl5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ0ODA4NjUsImV4cCI6MjA5MDA1Njg2NX0.2ATuH-jQBy17jEHrt3k6q-Mjif7ZA0w74Q0WO-qfebc';
const MY_EMAIL = 'maximilianpark101@gmail.com';

function checkVendorReplies() {
  var vendors = fetchVendors();
  if (!vendors || vendors.length === 0) return;

  vendors.forEach(function(vendor) {
    if (!vendor.email || vendor.status !== 'Sent') return;

    var reply = findThreadReply(vendor.email);
    if (reply) {
      updateVendor(vendor.id, {
        status: 'Replied',
        reply_snippet: reply.snippet,
        reply_date: reply.date,
        reply_from: reply.from
      });
    }
  });
}

/**
 * Fetch vendors from Supabase where status = 'Sent'
 */
function fetchVendors() {
  var response = UrlFetchApp.fetch(
    SUPABASE_URL + '/rest/v1/vendor_outreach?status=eq.Sent',
    {
      headers: {
        'apikey': SUPABASE_KEY,
        'Authorization': 'Bearer ' + SUPABASE_KEY
      }
    }
  );
  return JSON.parse(response.getContentText());
}

/**
 * Search Gmail for threads where we emailed this vendor address,
 * then check if ANYONE in the thread replied (not just that exact address).
 * This is the key fix — we track the THREAD, not the sender.
 */
function findThreadReply(vendorEmail) {
  // Find threads where we sent TO this vendor email
  var threads = GmailApp.search('to:' + vendorEmail + ' from:' + MY_EMAIL, 0, 5);

  for (var t = 0; t < threads.length; t++) {
    var messages = threads[t].getMessages();

    // Walk through all messages in the thread
    for (var m = 0; m < messages.length; m++) {
      var msg = messages[m];
      var sender = msg.getFrom();

      // Skip messages we sent ourselves
      if (sender.indexOf(MY_EMAIL) !== -1) continue;

      // This message is from someone else — it's a reply!
      var snippet = msg.getPlainBody();
      // Trim to first ~300 chars for the snippet
      if (snippet.length > 300) {
        snippet = snippet.substring(0, 300).trim() + '...';
      }

      // Clean up the sender display (extract "Name <email>" → "Name (email)")
      var senderClean = sender.replace(/</, '(').replace(/>/, ')');

      return {
        snippet: snippet,
        date: msg.getDate().toISOString(),
        from: senderClean
      };
    }
  }

  return null; // No reply found
}

/**
 * Update vendor record in Supabase
 */
function updateVendor(id, data) {
  UrlFetchApp.fetch(
    SUPABASE_URL + '/rest/v1/vendor_outreach?id=eq.' + id,
    {
      method: 'patch',
      headers: {
        'apikey': SUPABASE_KEY,
        'Authorization': 'Bearer ' + SUPABASE_KEY,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal'
      },
      payload: JSON.stringify(data)
    }
  );
}
