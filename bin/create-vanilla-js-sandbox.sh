#!/bin/bash

# Create HTML file
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Sandbox</title>
  <style></style>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <app-main></app-main>
  <script type="module"></script>
  <script src="script.js" type="module"></script>
</body>
</html>
EOF

# Create CSS file
cat <<EOF > style.css
:root {
    box-sizing: border-box;
}

*,
::before,
::after {
    box-sizing: inherit;
}

div {
    background-color: red;
}
EOF

# Create JavaScript file
cat <<'EOF' > script.js
//import sheet from 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css' assert { type: 'css' };

const template = document.createElement('template');

template.innerHTML = `
  <i class="fa-solid fa-spinner fa-spin-pulse"></i>
  <div>Hello World!</div><i class="fa-solid fa-font-awesome"></i>
`;

export default class AppMain extends HTMLElement {
    constructor() {
        super();
        this._shadowRoot = this.attachShadow({ 'mode': 'open' });
        this._shadowRoot.appendChild(template.content.cloneNode(true));
        //this._shadowRoot.adoptedStyleSheets = [sheet];
    }

    connectedCallback() {
    }
}

window.customElements.define('app-main', AppMain);
EOF

echo "Files created: index.html, style.css, script.js"

read -p "Start browser-sync? [Y/n] " answer
answer=${answer:-Y}

bsync_cmd="browser-sync . -f . --cors --no-notify --single"
if [[ "$answer" =~ ^[Yy]$ ]]; then
  if ! command -v browser-sync &> /dev/null; then
    echo "Error: browser-sync is not installed."
    echo "Install it with: npm install -g browser-sync"
    exit 1
  fi
  echo "Running $bsync_cmd"
  eval $bsync_cmd
else
  
  echo "You can start it manually with: $bsync_cmd?"
fi
