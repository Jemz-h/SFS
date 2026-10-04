# TASK
Audit and fix the UI of my web app "Student Feedback System" so it looks like a calm, professional analytics dashboard. Fix visual bugs, inconsistencies, and layout problems across every page, and apply one coherent design system. Do not change backend behavior.

# PROJECT CONTEXT
- App: Student Feedback System (students submit feedback, staff view and analyze it)
- Stack: C#/.NET web app. Inspect the project to confirm the exact UI technology (Razor views, Blazor, plain HTML/CSS/JS) and the front-end libraries already installed
- Database: MongoDB is NOT set up yet. Do not add, configure, or wire any database code. Do not touch models, controllers, routes, services, or data access
- Users: students (submit feedback) and staff/admin (review results)
- Main screens: [LIST YOUR PAGES, e.g. login, feedback form, dashboard, feedback list, reports]
- Known problems I see: [LIST ANYTHING OBVIOUS, e.g. misaligned form, inconsistent buttons, ugly tables, broken on mobile]

# DESIGN REFERENCE
- Structure and layout: Google Analytics 4 (GA4). Top app bar, left sidebar navigation, a page title with a filter bar, scorecards at the top of dashboards, clean data tables, and card-based sections
- Mood: calm, quiet, and professional. Think of the restraint of GA4, Stripe Dashboard, and Linear: lots of neutral surfaces, one blue accent, and information that does the talking
- If I attach screenshots, treat them as the visual reference and match their density and spacing

# DESIGN SYSTEM (use exactly this; define as CSS variables in one central stylesheet)
Colors
- Page background #F4F6F9, surface (cards/panels) #FFFFFF with 1px border #E1E6EC
- Primary #3B6FA8 (hover #315E91, pressed #284F7A), primary tint #E8EFF7 for active nav and selected rows
- Text: primary #1F2937, secondary #5B6573, muted #8A94A3
- Chart colors: a single blue scale (#3B6FA8, #6F97C4, #A9C2DE, #D3E0EE) plus one neutral gray
- Status colors, sparingly: success #3F8F6B, warning #B7791F, error #B84A4A
Typography
- One family only: Inter or Roboto with a system fallback stack
- Sizes: 12, 14, 16, 20, 28px. Body 14px. Weights 400 and 500 only
- Tabular numbers for metrics and tables
Shape and spacing
- 4px/8px spacing grid. Radius 6px for inputs and buttons, 8px max for cards
- Shadows: none, or at most 0 1px 2px rgba(16,24,40,0.04)
- Hover and focus transitions: color changes only, 150ms

# LAYOUT AND COMPONENTS
- Top bar (56px): app name left, optional search center, user menu right
- Sidebar (240px): icon + label, small muted section headings, active item uses primary tint with primary text, collapses on mobile
- Dashboard: scorecards (small label, large number, plain-text trend like "+4.2%"), then charts, then a table
- Tables: sticky header, thin dividers, subtle row hover, pagination, sortable columns where useful, right-aligned numbers
- Forms: labels above inputs, 1px borders, clear focus ring in primary color, inline validation messages, sensible tab order
- Charts: use the library already in the project, otherwise Chart.js. Thin lines, light gridlines, single-hue blues, no 3D, no unnecessary legends
- Empty, loading, and error states for every list and chart, written in plain, specific language
- Fully responsive: desktop, tablet, and mobile

# ANTI-SLOP RULES (strict, treat violations as bugs)
- No gradients anywhere (backgrounds, buttons, text, cards, charts)
- No glassmorphism, blur, glow, neon, or animated shimmer effects
- No purple/indigo accents and no multi-color rainbow card accents
- No emoji in the UI and no decorative icon on every card or heading
- No oversized rounded corners, pill-shaped everything, or heavy drop shadows
- No hover lift, scale, or bounce animations
- No hero banners, marketing headlines, or filler copy such as "Welcome back! Here's what's happening"
- Copy must be specific to this system (feedback, courses, instructors, ratings, comments). No lorem ipsum, no generic "Item 1" placeholders
- No centered-everything layouts, no excessive padding, no card nested inside card inside card
- Do not add dependencies unless truly necessary
- Icons: one consistent outline set (for example Material Symbols Outlined), used only for navigation and actions where they help
- In any text you write for the UI, do not use em dashes

# HARD CONSTRAINTS
- Do not change backend code, routes, model properties, form field names, IDs, or anything the server binds to
- Do not add fake data that looks real without marking it clearly as sample data in code comments. If a page needs data that does not exist yet, build the UI against a clearly labeled placeholder and tell me
- Keep accessibility intact or better: WCAG AA contrast, visible keyboard focus, labels on all inputs, semantic HTML
- Keep code clean and reusable: one shared layout, shared partials/components, one main stylesheet, no inline styles, no duplicated CSS

# WORKFLOW
1. AUDIT: Read the project and list every UI problem you find, grouped by page (layout bugs, inconsistent components, responsive issues, accessibility issues, anything that looks generic or AI-generated). Show me this list before changing anything
2. PLAN: State the files you will create or edit and the order
3. BUILD: Implement the design tokens and shared layout first, then base components, then each page one by one
4. SELF-REVIEW: Check every page against the anti-slop rules and the design system. Fix any violation you find
5. REPORT: List every file changed, what was fixed per page, anything you could not fix and why, and how to run and preview the app

# DEFINITION OF DONE
- Every page uses the same layout, colors, type scale, and components
- No page has horizontal scroll, overlapping elements, or unreadable text at 375px, 768px, and 1440px widths
- Zero gradients, emoji, or decorative effects remain
- The app builds and runs, and all existing functionality still works