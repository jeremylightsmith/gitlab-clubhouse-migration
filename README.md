# gitlab-clubhouse-migration

We had to migrate from gitlab to clubhouse. Maybe this will be a good starting point for you too. We did this once and I expect you'll need to tweak this.

## Setup environment variables

Create a `.env` file with your credentials:

```
GITLAB_ACCESS_TOKEN="..."
CLUBHOUSE_API_TOKEN="..."
```

## Export from Gitlab

Run the exporting script:

```
bin/export_gitlab_issues [group name] [project name]
```

this will save to `issues.json`

## Import to Clubhouse

You'll need to customize the `translate_labels` function at the top of the `import_clubhouse_stories` script, so that it understands your gitlab labels. After that, run it:

```
bin/import_clubhouse_stories
```

That's it!