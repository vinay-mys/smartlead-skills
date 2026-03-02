---
name: smart-delivery
description: >-
  When the user wants to test email deliverability, run spam placement tests, or check
  email authentication in Smartlead. Also use when the user mentions "deliverability,"
  "spam test," "placement test," "DKIM," "SPF," "rDNS," "blacklist," "inbox placement."
  For email account setup, see email-account-management. For domain purchasing, see smart-senders.
metadata:
  version: 1.0.0
---

# Smart Delivery

Role: Expert in Smartlead email deliverability testing. Goal: help users run placement tests, diagnose deliverability issues, and monitor email authentication.

Context Check: Read smartlead-context first.

Initial Assessment:
1. Goal (run new test, check results, monitor authentication, check blacklists)
2. Test type (manual one-time or automated recurring)
3. Specific provider/region focus
4. Email accounts to test
5. Folder organization needs

Core endpoints organized by workflow:

**Test Management:**
- POST /smart-delivery/manual-test - Create manual placement test
- POST /smart-delivery/automated-test - Create automated recurring test
- GET /smart-delivery/test/{id} - Get test details
- PUT /smart-delivery/test/{id}/stop - Stop automated test
- POST /smart-delivery/tests/delete - Delete tests in bulk
- POST /smart-delivery/tests - List all tests

**Reports:**
- POST /smart-delivery/report/provider - Provider-wise report
- POST /smart-delivery/report/geo - Geo-wise report
- GET /smart-delivery/report/sender - Sender account report
- GET /smart-delivery/report/spam-filter - Spam filter report

**Authentication:**
- GET /smart-delivery/dkim/{id} - DKIM details
- GET /smart-delivery/spf/{id} - SPF details
- GET /smart-delivery/rdns/{id} - rDNS report

**Blacklists:**
- GET /smart-delivery/blacklists - IP blacklists
- GET /smart-delivery/domain-blacklist - Domain blacklist
- GET /smart-delivery/test/{id}/ip-blacklist - IP blacklist count

**Infrastructure:**
- GET /smart-delivery/providers - Region-wise provider IDs
- GET /smart-delivery/sender-accounts - Sender account list
- GET /smart-delivery/mailbox-summary - Mailbox summary
- GET /smart-delivery/mailbox-count - Mailbox count

**Folders:**
- GET /smart-delivery/folders - List folders
- POST /smart-delivery/folders - Create folder
- GET /smart-delivery/folders/{id} - Get folder
- DELETE /smart-delivery/folders/{id} - Delete folder

**Other:**
- GET /smart-delivery/test/{id}/content - Email content
- GET /smart-delivery/test/{id}/reply-headers - Reply headers
- GET /smart-delivery/test/{id}/schedule-history - Schedule history
- GET /smart-delivery/test/{id}/ip-details - IP details

Deliverability workflow:
1. Check authentication (DKIM, SPF, rDNS)
2. Run manual placement test
3. Review provider-wise and geo-wise reports
4. Check blacklists
5. Set up automated tests for ongoing monitoring

Common Mistakes:
- Not checking DKIM/SPF before running tests
- Running tests from accounts that are still warming up
- Ignoring spam filter reports
- Not organizing tests into folders
- Deleting automated tests instead of stopping them

Related Skills: smartlead-context, email-account-management, smart-senders, campaign-management, campaign-analytics, global-analytics
