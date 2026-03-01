# Folder `glance`

Implements the Glance feature.

`GlanceSitemapView` provides a compact view that reads the sitemap label from persistent storage and displays it in the glance carousel.

When the app is launched in glance mode, `OHApp.getGlanceView()` acts as the entry point and prepares the corresponding view.

---

## Memory Constraints

When running as a glance, available memory is very limited. Connect IQ supports scoped classes and resources for this purpose. Classes required in glance mode must be annotated with `(:glance)`, and only the strictly necessary classes should be included in this scope.
