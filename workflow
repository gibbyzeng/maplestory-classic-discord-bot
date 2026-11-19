.github/workflows/maple-bot.yml

name: MapleStory Classic Discord Updates

on:
  schedule:
    - cron: "*/10 * * * *"
  workflow_dispatch:

permissions:
  contents: write

jobs:
  check-updates:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: pip install requests beautifulsoup4

      - name: Run MapleStory bot
        env:
          DISCORD_WEBHOOK: ${{ secrets.DISCORD_WEBHOOK }}
        run: python bot.py

      - name: Save seen announcements
        run: |
          git config user.name "MapleStory Bot"
          git config user.email "bot@users.noreply.github.com"
          git add seen.json
          git diff --cached --quiet || git commit -m "Update seen announcements"
          git push
