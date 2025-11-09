Excellent question — and one that’s especially relevant if you want **English (Latin)** and **Gujarati (Indic)** text to both look good on Ubuntu (which doesn’t always choose great fonts automatically).

Let’s walk through the proper way to set **different fonts per language/script** in Ubuntu (or any Linux desktop that uses **fontconfig** — which most do).

---

## 🧩 Goal

You want:

* English text (Latin script) → one font, e.g. **"Ubuntu"**
* Gujarati text → another font, e.g. **"Shruti"**, **"Noto Sans Gujarati"**, or **"Lohit Gujarati"**

---

## 🧰 Method 1 — System-wide via Fontconfig XML

Fontconfig is the low-level system that handles fonts for most Linux apps (GTK, Qt, browsers, etc.).

### Step 1. Create a config file

Create a file named:

```
~/.config/fontconfig/fonts.conf
```

(if directory doesn’t exist, create it)

### Step 2. Add this XML content:

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>

  <!-- Default font for Latin (English) -->
  <match>
    <test name="lang" compare="contains">
      <string>en</string>
    </test>
    <edit name="family" mode="assign" binding="strong">
      <string>Ubuntu Mono</string>
    </edit>
  </match>

  <!-- Font for Gujarati -->
  <match>
    <test name="lang" compare="contains">
      <string>gu</string>
    </test>
    <edit name="family" mode="assign" binding="strong">
      <string>Noto Serif Gujarati</string>
    </edit>
  </match>

</fontconfig>
```

You can replace `Noto Sans Gujarati` with `Shruti`, `Lohit Gujarati`, or any installed Gujarati font.

### Step 3. Rebuild font cache

```bash
fc-cache -fv
```

### Step 4. Test

Run:

```bash
fc-match :lang=en
fc-match :lang=gu
```

✅ Expected output:

* English → `Ubuntu-Regular.ttf`
* Gujarati → `NotoSansGujarati-Regular.ttf` (or whichever you set)

---

## 🧭 Method 2 — Per-app (e.g. for terminal, editor, or browser)

If you just want Gujarati to appear differently in **one app**, change font fallback there:

* **GNOME Terminal → Preferences → Text → Custom font**
* **VS Code** → `settings.json`:

  ```json
  "editor.fontFamily": "Ubuntu, 'Noto Sans Gujarati'"
  ```

  (VS Code automatically switches between them when Gujarati text appears.)
* **LibreOffice** → Tools → Options → Fonts → "Complex Text Layout" tab → set Gujarati font.

---

## 🧠 Tip: Mixing Fonts Gracefully

If you often mix Gujarati + English in the same text (like bilingual writing), use fonts that have **similar line height** and **x-height** so the transition looks natural:

* **English:** Noto Sans, Ubuntu
* **Gujarati:** Noto Sans Gujarati (best match with Noto Sans)

---

## 🧹 Bonus: See all available Gujarati fonts

```bash
fc-list :lang=gu | cut -d: -f2 | sort -u
```

---

Would you like me to show a **ready-made config** for a *bilingual developer setup* — for example, Ubuntu (English) + Gujarati text in editors and terminals with matching look?
