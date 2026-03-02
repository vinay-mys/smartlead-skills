import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def read(rel_path: str) -> str:
    return (ROOT / rel_path).read_text()


class TestApiDocAlignment(unittest.TestCase):
    def test_context_index_has_corrected_endpoints(self) -> None:
        text = read("skills/smartlead-context/references/api-endpoints.md")
        self.assertIn("`/campaigns/create-subsequence`", text)
        self.assertIn("`/campaigns/{id}/webhooks`", text)
        self.assertIn("`/campaigns/{id}/webhooks/summary`", text)
        self.assertIn("`/campaigns/{id}/webhooks/retrigger-failed-events`", text)

        self.assertNotIn("`/campaigns/{id}/subsequence`", text)
        self.assertNotIn("`/campaigns/{id}/webhooks/{wid}`", text)
        self.assertNotIn("`/webhooks/publish-summary`", text)
        self.assertNotIn("`/webhooks/retrigger`", text)

    def test_campaign_subsequence_path_is_updated_everywhere(self) -> None:
        skill = read("skills/campaign-management/SKILL.md")
        ref = read("skills/campaign-management/references/campaign-endpoints.md")

        self.assertIn("POST /campaigns/create-subsequence?api_key={api_key}", skill)
        self.assertIn(
            "POST https://server.smartlead.ai/api/v1/campaigns/create-subsequence?api_key={api_key}",
            ref,
        )

        self.assertNotIn("/campaigns/{campaign_id}/subsequence", skill)
        self.assertNotIn("/campaigns/{campaign_id}/subsequence", ref)

    def test_webhook_paths_and_payloads_are_updated(self) -> None:
        skill = read("skills/webhook-management/SKILL.md")
        ref = read("skills/webhook-management/references/webhook-endpoints.md")

        for text in (skill, ref):
            self.assertIn("/campaigns/{campaign_id}/webhooks?api_key={API_KEY}", text)
            self.assertIn("/campaigns/{campaign_id}/webhooks/summary", text)
            self.assertIn(
                "/campaigns/{campaign_id}/webhooks/retrigger-failed-events", text
            )
            self.assertIn('"fromTime"', text)
            self.assertIn('"toTime"', text)

            self.assertNotIn("/webhooks/publish-summary?", text)
            self.assertNotIn("/webhooks/retrigger?", text)
            self.assertNotIn("/webhooks/{webhook_id}", text)
            self.assertNotIn('"webhook_ids"', text)
            self.assertNotIn('"event_types"', text)


if __name__ == "__main__":
    unittest.main()
