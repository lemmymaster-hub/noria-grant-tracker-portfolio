# Noria Grant Tracker

A grant and accelerator tracking interface for Noria Technologies, prepared as a separate portfolio source snapshot.

## Status

Portfolio source snapshot prepared on 5 November 2026. Active development; feature descriptions are based on the retrieved source, not a claim of external production validation.

## What it does

- Compare opportunities in a dense table.
- Filter and review deadlines, funding, relevance and assessments.
- Edit application status and notes.
- Persist shared changes through a separately configured Supabase table.

The operational repository stays private. This portfolio copy has no production database URL/key and no embedded live grant list. It does not connect to the live tracker.

## Interface reasoning

Status colour and deadline information help users prioritise a long opportunity list. Assessments and notes keep project reasoning near the record. The interface combines browsing and editing so users do not need a separate spreadsheet.

## Run and inspect

Serve the HTML with `python3 -m http.server 8000` and open http://localhost:8000.

Shared-data operations require a separate backend. Configure DB_URL and DB_KEY in index.html only for a disposable demo Supabase project. Never use a service-role key. The reference SQL retains the original intentionally collaborative anonymous-write policies: do not apply them to a private or production dataset. The source snapshot can be inspected without this setup; persistence is not configured.

## Contribution and tooling

Mile Vujasin: product requirements, interface direction, iterative design decisions and implementation work using AI-assisted development. Third-party frameworks, libraries and bundled assets remain the work of their respective authors. This repository does not claim that every line was manually written or that user-research outcomes have been formally measured.

## Portfolio hygiene

No Git history, production database export, private workflow notes, authentication tokens or original hosting project identity are included. A separate environment is needed for backend operations. No open-source licence for the original application is granted by this snapshot; third-party notices are retained.
