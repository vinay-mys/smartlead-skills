# Smartlead API Endpoint Index

Base URL: `https://server.smartlead.ai/api/v1`

All endpoints require `?api_key={API_KEY}` as a query parameter.

## Campaign Management

| Method | Path | Description |
|---|---|---|
| POST | `/campaigns/create` | Create a new campaign |
| POST | `/campaigns/{id}/schedule` | Update campaign schedule |
| POST | `/campaigns/{id}/settings` | Update general settings |
| GET | `/campaigns/{id}` | Get campaign by ID |
| POST | `/campaigns/{id}/sequences` | Save campaign sequence |
| GET | `/campaigns` | List all campaigns |
| POST | `/campaigns/{id}/status` | Patch campaign status |
| GET | `/campaigns/{id}/sequences` | Fetch sequences by campaign ID |
| GET | `/leads/{lead_id}/campaigns` | Fetch campaigns by lead ID |
| GET | `/campaigns/{id}/leads-export` | Export campaign data as CSV |
| DELETE | `/campaigns/{id}` | Delete a campaign |
| GET | `/campaigns/{id}/sequence-analytics` | Get sequence analytics |
| POST | `/campaigns/{id}/subsequence` | Create subsequence |

## Lead Management

| Method | Path | Description |
|---|---|---|
| POST | `/campaigns/{id}/leads` | Add leads to campaign |
| GET | `/campaigns/{id}/leads` | List leads by campaign ID |
| GET | `/leads/?email={email}` | Fetch lead by email |
| GET | `/leads/categories` | Fetch lead categories |
| POST | `/campaigns/{cid}/leads/{lid}` | Update lead by ID |
| POST | `/campaigns/{cid}/leads/{lid}/resume` | Resume lead |
| POST | `/campaigns/{cid}/leads/{lid}/pause` | Pause lead |
| DELETE | `/campaigns/{cid}/leads/{lid}` | Delete lead from campaign |
| POST | `/campaigns/{cid}/leads/{lid}/unsubscribe` | Unsubscribe lead from campaign |
| POST | `/leads/{lid}/unsubscribe` | Unsubscribe lead globally |
| POST | `/leads/add-domain-block-list` | Add to global block list |
| DELETE | `/leads/domain-block-list` | Remove from block list |
| GET | `/leads/domain-block-list` | Fetch global block list |
| GET | `/leads` | Fetch all leads from account |
| POST | `/campaigns/{cid}/leads/{lid}/category` | Update lead category |
| GET | `/campaigns/{cid}/leads/{lid}/message-history` | Lead message history |
| POST | `/leads/move-inactive` | Move leads to inactive |
| POST | `/campaigns/{id}/leads/push` | Push leads/list to campaign |

## Email Accounts

| Method | Path | Description |
|---|---|---|
| POST | `/email-accounts/save` | Create/update email account |
| GET | `/email-accounts/` | List all email accounts |
| GET | `/email-accounts/{id}` | Fetch account by ID |
| POST | `/email-accounts/{id}` | Update email account |
| GET | `/campaigns/{id}/email-accounts` | List accounts per campaign |
| POST | `/campaigns/{id}/email-accounts` | Add account to campaign |
| DELETE | `/campaigns/{id}/email-accounts` | Remove account from campaign |
| POST | `/email-accounts/{id}/warmup` | Add/update warmup settings |
| GET | `/email-accounts/{id}/warmup-stats` | Fetch warmup stats |
| POST | `/email-accounts/reconnect` | Reconnect failed accounts |
| POST | `/email-accounts/{id}/tag` | Update account tag |
| POST | `/email-accounts/tags/add` | Add tags to accounts |
| DELETE | `/email-accounts/tags/remove` | Remove tags from accounts |
| POST | `/email-accounts/tags/list` | Get tags by email addresses |
| POST | `/email-accounts/{id}/messages` | Fetch messages for account |
| POST | `/email-accounts/messages/bulk` | Bulk fetch messages |

## Campaign Statistics

| Method | Path | Description |
|---|---|---|
| GET | `/campaigns/{id}/statistics` | Campaign stats by ID |
| GET | `/campaigns/{id}/statistics-by-date` | Stats by ID and date range |
| GET | `/campaigns/{id}/analytics` | Top level analytics |
| GET | `/campaigns/{id}/analytics-by-date` | Analytics by date range |
| GET | `/campaigns/{id}/lead-statistics` | Lead statistics |
| GET | `/campaigns/{id}/mailbox-statistics` | Mailbox statistics |

## Master Inbox

| Method | Path | Description |
|---|---|---|
| POST | `/inbox/replies` | Fetch inbox replies |
| POST | `/inbox/unread` | Fetch unread replies |
| POST | `/inbox/snoozed` | Fetch snoozed messages |
| POST | `/inbox/important` | Fetch important messages |
| POST | `/inbox/scheduled` | Fetch scheduled messages |
| POST | `/inbox/reminders` | Fetch messages with reminders |
| POST | `/inbox/archived` | Fetch archived messages |
| GET | `/inbox/lead/{id}` | Fetch lead by ID |
| GET | `/inbox/untracked` | Fetch untracked replies |
| POST | `/campaigns/{cid}/leads/{lid}/reply` | Reply to lead |
| POST | `/campaigns/{cid}/leads/{lid}/forward` | Forward a reply |
| PATCH | `/inbox/lead/{id}/revenue` | Update lead revenue |
| PATCH | `/inbox/lead/{id}/category` | Update lead category |
| POST | `/inbox/lead/{id}/task` | Create lead task |
| POST | `/inbox/lead/{id}/note` | Create lead note |
| POST | `/inbox/block-domains` | Block domains |
| PATCH | `/inbox/lead/{id}/resume` | Resume lead |
| PATCH | `/inbox/lead/{id}/read-status` | Change read status |
| POST | `/inbox/lead/{id}/reminder` | Set reminder |
| POST | `/inbox/lead/{id}/subsequence` | Push to subsequence |
| POST | `/inbox/lead/{id}/team-member` | Update team member |

## Webhooks

| Method | Path | Description |
|---|---|---|
| GET | `/campaigns/{id}/webhooks` | Fetch webhooks by campaign |
| POST | `/campaigns/{id}/webhooks` | Add/update webhook |
| DELETE | `/campaigns/{id}/webhooks/{wid}` | Delete webhook |
| GET | `/webhooks/publish-summary` | Get publish summary |
| POST | `/webhooks/retrigger` | Retrigger failed events |

## Client Management

| Method | Path | Description |
|---|---|---|
| POST | `/client/save` | Add client to system |
| GET | `/clients` | Fetch all clients |
| POST | `/client/{id}/api-key` | Create client API key |
| GET | `/client/{id}/api-keys` | Get client API keys |
| DELETE | `/client/{id}/api-key/{kid}` | Delete client API key |
| PUT | `/client/{id}/api-key/{kid}/reset` | Reset client API key |

## Smart Delivery

| Method | Path | Description |
|---|---|---|
| GET | `/smart-delivery/providers` | Region-wise provider IDs |
| POST | `/smart-delivery/manual-test` | Create manual placement test |
| POST | `/smart-delivery/automated-test` | Create automated test |
| GET | `/smart-delivery/test/{id}` | Spam test details |
| POST | `/smart-delivery/tests/delete` | Delete tests in bulk |
| PUT | `/smart-delivery/test/{id}/stop` | Stop automated test |
| POST | `/smart-delivery/tests` | List all tests |
| POST | `/smart-delivery/report/provider` | Provider-wise report |
| POST | `/smart-delivery/report/geo` | Geo-wise report |
| GET | `/smart-delivery/report/sender` | Sender account report |
| GET | `/smart-delivery/report/spam-filter` | Spam filter report |
| GET | `/smart-delivery/dkim/{id}` | DKIM details |
| GET | `/smart-delivery/spf/{id}` | SPF details |
| GET | `/smart-delivery/rdns/{id}` | rDNS report |
| GET | `/smart-delivery/sender-accounts` | Sender account list |
| GET | `/smart-delivery/blacklists` | Blacklists |
| GET | `/smart-delivery/domain-blacklist` | Domain blacklist |
| GET | `/smart-delivery/test/{id}/content` | Test email content |
| GET | `/smart-delivery/test/{id}/ip-blacklist` | IP blacklist count |
| GET | `/smart-delivery/test/{id}/reply-headers` | Email reply headers |
| GET | `/smart-delivery/test/{id}/schedule-history` | Schedule history |
| GET | `/smart-delivery/test/{id}/ip-details` | IP details |
| GET | `/smart-delivery/mailbox-summary` | Mailbox summary |
| GET | `/smart-delivery/mailbox-count` | Mailbox count |
| GET | `/smart-delivery/folders` | Get all folders |
| POST | `/smart-delivery/folders` | Create folder |
| GET | `/smart-delivery/folders/{id}` | Get folder by ID |
| DELETE | `/smart-delivery/folders/{id}` | Delete folder |

## Smart Prospect

| Method | Path | Description |
|---|---|---|
| GET | `/prospect/departments` | Get departments |
| GET | `/prospect/cities` | Get cities |
| GET | `/prospect/countries` | Get countries |
| GET | `/prospect/states` | Get states |
| GET | `/prospect/industries` | Get industries |
| GET | `/prospect/sub-industries` | Get sub-industries |
| GET | `/prospect/head-counts` | Get head counts |
| GET | `/prospect/levels` | Get levels |
| GET | `/prospect/revenue-options` | Get revenue options |
| GET | `/prospect/companies` | Get companies |
| GET | `/prospect/domains` | Get domains |
| GET | `/prospect/job-titles` | Get job titles |
| GET | `/prospect/keywords` | Get keywords |
| POST | `/prospect/search` | Search contacts |
| POST | `/prospect/fetch` | Fetch contacts |
| POST | `/prospect/contacts` | Get contacts |
| PATCH | `/prospect/review` | Review contacts |
| GET | `/prospect/saved-searches` | Get saved searches |
| GET | `/prospect/recent-searches` | Get recent searches |
| GET | `/prospect/fetched-searches` | Get fetched searches |
| POST | `/prospect/save-search` | Save search |
| PUT | `/prospect/saved-search/{id}` | Update saved search |
| PUT | `/prospect/fetched-lead/{id}` | Update fetched lead |
| GET | `/prospect/search-analytics` | Search analytics |
| GET | `/prospect/reply-analytics` | Reply analytics |
| POST | `/prospect/find-emails` | Find emails |

## Global Analytics

| Method | Path | Description |
|---|---|---|
| GET | `/analytics/campaigns` | Campaign list |
| GET | `/analytics/clients` | Client list |
| GET | `/analytics/client-count` | Month-wise client count |
| GET | `/analytics/overall-stats` | Overall stats |
| GET | `/analytics/day-wise-stats` | Day-wise overall stats |
| GET | `/analytics/day-wise-stats-sent-time` | Day-wise stats by sent time |
| GET | `/analytics/positive-reply-stats` | Day-wise positive reply stats |
| GET | `/analytics/positive-reply-stats-sent-time` | Positive reply by sent time |
| GET | `/analytics/campaign-stats` | Campaign overall stats |
| GET | `/analytics/client-stats` | Client overall stats |
| GET | `/analytics/email-health` | Email-wise health metrics |
| GET | `/analytics/domain-health` | Domain-wise health metrics |
| GET | `/analytics/provider-performance` | Provider-wise performance |
| GET | `/analytics/team-board` | Team board stats |
| GET | `/analytics/lead-stats` | Lead overall stats |
| GET | `/analytics/lead-category-response` | Lead category response |
| GET | `/analytics/first-reply-time` | Time to first reply |
| GET | `/analytics/follow-up-reply-rate` | Follow-up reply rate |
| GET | `/analytics/lead-reply-time` | Lead to reply time |
| GET | `/analytics/campaign-response` | Campaign response stats |
| GET | `/analytics/campaign-status` | Campaign status stats |
| GET | `/analytics/mailbox-stats` | Mailbox overall stats |

## Smart Senders

| Method | Path | Description |
|---|---|---|
| GET | `/smart-senders/otp/{mailbox_id}` | Get OTP for admin mailbox |
| POST | `/smart-senders/auto-generate` | Auto generate mailboxes |
| GET | `/smart-senders/search-domain` | Search domain availability |
| GET | `/smart-senders/vendors` | Get vendors |
| POST | `/smart-senders/order` | Place order |
| GET | `/smart-senders/domains` | Get purchased domains |
| GET | `/smart-senders/orders/{id}` | Get order details |
