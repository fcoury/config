---
name: designing-ratatui-tuis
description: Design and improve Ratatui TUI applications with modern, polished aesthetics. Use when creating terminal apps, improving TUI look and feel, designing layouts, or working with Ratatui components in Rust.
---

# Designing Ratatui TUIs

Create modern, polished terminal interfaces inspired by tools like Opencode and Neovim.

## Quick Start

Modern TUI design priorities:
1. **Visual hierarchy** - Guide the eye with contrast and spacing
2. **Restrained color** - Muted backgrounds, strategic accent colors
3. **Generous whitespace** - Let content breathe
4. **Consistent borders** - Rounded or clean, never mixed

## Color Philosophy

### Base Palette

Use a dark, muted background with layered surfaces:

```rust
// Background layers (dark to light for depth)
let bg_base = Color::Rgb(22, 22, 30);      // Deepest background
let bg_surface = Color::Rgb(30, 30, 40);   // Panels, cards
let bg_elevated = Color::Rgb(40, 40, 52);  // Modals, dropdowns

// Text hierarchy
let text_primary = Color::Rgb(220, 220, 230);   // Main content
let text_secondary = Color::Rgb(140, 140, 160); // Labels, hints
let text_muted = Color::Rgb(90, 90, 110);       // Disabled, decorative

// Accent colors (use sparingly)
let accent_primary = Color::Rgb(130, 170, 255);  // Selection, focus
let accent_success = Color::Rgb(130, 200, 140);  // Success states
let accent_warning = Color::Rgb(230, 180, 100);  // Warnings
let accent_error = Color::Rgb(230, 120, 120);    // Errors
```

### Color Rules

- **80% neutral** - Most UI should be grays
- **15% subtle** - Secondary colors for structure
- **5% accent** - Highlights, focus states, CTAs
- **Never pure black/white** - Too harsh; use near-black/off-white

## Border Styles

### Modern Rounded Borders

```rust
use ratatui::symbols::border;

// Preferred: Rounded corners for modern feel
let block = Block::default()
    .borders(Borders::ALL)
    .border_set(border::ROUNDED)
    .border_style(Style::default().fg(Color::Rgb(60, 60, 80)));

// Alternative: Clean single lines for dense UIs
let block = Block::default()
    .borders(Borders::ALL)
    .border_set(border::PLAIN)
    .border_style(Style::default().fg(Color::Rgb(50, 50, 65)));
```

### Border Hierarchy

```rust
// Active/focused panel - brighter border + accent
.border_style(Style::default().fg(accent_primary))

// Inactive panel - subtle border
.border_style(Style::default().fg(Color::Rgb(50, 50, 65)))

// Decorative/grouping - very subtle
.border_style(Style::default().fg(Color::Rgb(35, 35, 45)))
```

## Spacing & Layout

### Generous Margins

```rust
// Inner padding for content blocks
let inner_area = area.inner(Margin { horizontal: 2, vertical: 1 });

// Panel spacing
let chunks = Layout::default()
    .direction(Direction::Horizontal)
    .constraints([
        Constraint::Percentage(30),
        Constraint::Length(1),  // Gap between panels
        Constraint::Percentage(70),
    ])
    .split(area);
```

### Visual Breathing Room

- Minimum 1 character padding inside bordered blocks
- 1-2 character gaps between major sections
- Empty lines between logical groups in lists

## Layout Patterns

### Sidebar + Main Content

```rust
let layout = Layout::default()
    .direction(Direction::Horizontal)
    .constraints([
        Constraint::Length(30),      // Fixed sidebar
        Constraint::Min(50),         // Flexible main area
    ])
    .split(frame.area());

let sidebar_area = layout[0];
let main_area = layout[1];
```

### Header + Content + Footer

```rust
let layout = Layout::default()
    .direction(Direction::Vertical)
    .constraints([
        Constraint::Length(3),       // Header/title bar
        Constraint::Min(10),         // Main content
        Constraint::Length(1),       // Status bar
    ])
    .split(frame.area());
```

### Centered Modal

```rust
fn centered_rect(percent_x: u16, percent_y: u16, r: Rect) -> Rect {
    let popup_layout = Layout::default()
        .direction(Direction::Vertical)
        .constraints([
            Constraint::Percentage((100 - percent_y) / 2),
            Constraint::Percentage(percent_y),
            Constraint::Percentage((100 - percent_y) / 2),
        ])
        .split(r);

    Layout::default()
        .direction(Direction::Horizontal)
        .constraints([
            Constraint::Percentage((100 - percent_x) / 2),
            Constraint::Percentage(percent_x),
            Constraint::Percentage((100 - percent_x) / 2),
        ])
        .split(popup_layout[1])[1]
}
```

## Component Patterns

### List with Selection

```rust
let items: Vec<ListItem> = entries
    .iter()
    .enumerate()
    .map(|(i, entry)| {
        let style = if i == selected_index {
            Style::default()
                .fg(text_primary)
                .bg(accent_primary.with_alpha(0.2))
        } else {
            Style::default().fg(text_secondary)
        };
        ListItem::new(entry.name.clone()).style(style)
    })
    .collect();

let list = List::new(items)
    .block(Block::default()
        .title(" Files ")
        .title_style(Style::default().fg(text_secondary).bold())
        .borders(Borders::ALL)
        .border_set(border::ROUNDED))
    .highlight_symbol("▸ ")
    .highlight_style(Style::default().add_modifier(Modifier::BOLD));
```

### Status Bar

```rust
let status_left = Span::styled(
    format!(" {} ", mode_name),
    Style::default().fg(bg_base).bg(accent_primary).bold()
);

let status_right = Span::styled(
    format!(" {}:{} ", line, col),
    Style::default().fg(text_muted)
);

let status = Paragraph::new(Line::from(vec![
    status_left,
    Span::raw(" "),
    Span::styled(filename, Style::default().fg(text_secondary)),
    Span::raw(" "),  // Spacer
    status_right,
]))
.style(Style::default().bg(bg_surface));
```

### Tab Bar

```rust
let titles: Vec<Line> = tabs
    .iter()
    .enumerate()
    .map(|(i, title)| {
        let style = if i == active_tab {
            Style::default().fg(accent_primary).bold()
        } else {
            Style::default().fg(text_muted)
        };
        Line::styled(format!(" {} ", title), style)
    })
    .collect();

let tabs = Tabs::new(titles)
    .select(active_tab)
    .divider(Span::styled("│", Style::default().fg(Color::Rgb(50, 50, 65))))
    .highlight_style(Style::default().fg(accent_primary).bold());
```

## Interaction Patterns

### Focus Indication

```rust
fn panel_style(focused: bool) -> Block<'static> {
    let border_color = if focused {
        accent_primary
    } else {
        Color::Rgb(50, 50, 65)
    };

    Block::default()
        .borders(Borders::ALL)
        .border_set(border::ROUNDED)
        .border_style(Style::default().fg(border_color))
}
```

### Keyboard Hints

Display available keys in status bar or footer:

```rust
let hints = vec![
    ("↑↓", "navigate"),
    ("enter", "select"),
    ("q", "quit"),
];

let hint_spans: Vec<Span> = hints
    .iter()
    .flat_map(|(key, action)| vec![
        Span::styled(format!(" {} ", key), Style::default().fg(accent_primary).bold()),
        Span::styled(*action, Style::default().fg(text_muted)),
    ])
    .collect();
```

### Loading States

```rust
let spinner_frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
let frame = spinner_frames[tick % spinner_frames.len()];

let loading = Paragraph::new(format!("{} Loading...", frame))
    .style(Style::default().fg(text_muted));
```

## Guidelines

- **Test in multiple terminals** - Colors render differently in iTerm2, Alacritty, Terminal.app
- **Support 16-color fallback** - Define named color alternatives for basic terminals
- **Respect terminal size** - Use `Constraint::Min` and `Constraint::Max` for responsive layouts
- **Dim inactive elements** - Clear visual hierarchy between focused and unfocused
- **Animate sparingly** - Spinners for loading, subtle cursor blink, nothing flashy
