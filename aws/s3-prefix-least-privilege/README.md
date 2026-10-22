# S3 prefix least privilege

An IAM policy that limits S3 read access to one prefix ("folder") in a bucket, tested with the IAM policy simulator.

## The policy
`policy.json` allows `s3:GetObject` only on keys that start with `reports/`.

## Tests (IAM policy simulator, Principal mode, test user with only this policy)

| Policy Resource | Request (`s3:GetObject`) | Result |
|---|---|---|
| `arn:aws:s3:::blessen-lab-s3-2210` (bucket only) | `reports/a.txt` | Implicit deny: no statement matched |
| `arn:aws:s3:::blessen-lab-s3-2210/reports/*` | `reports/a.txt` | Allowed: explicit allow |
| `arn:aws:s3:::blessen-lab-s3-2210/reports/*` | `photo.jpg` | Implicit deny: no statement matched |

## What I learned
- The bucket ARN (`arn:aws:s3:::bucket`) is for bucket actions such as `s3:ListBucket`. Object actions such as `s3:GetObject` need `arn:aws:s3:::bucket/*`.
- S3 storage is flat: console "folders" are key prefixes, so `bucket/reports/*` grants one prefix only.
- The console accepted the broken bucket-only policy without a warning, so I test policies before relying on them.
- Least privilege: give each app or team access to its own prefix only.

## Notes
- Read access only. Listing keys (`s3:ListBucket`) needs a separate statement on the bucket ARN, not included here.
- Lab account. No account IDs or credentials in this repo.