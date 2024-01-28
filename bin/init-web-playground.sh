#!/bin/bash
set -e

cat << 'EOF' > index.html
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>hello webstandards</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" media="screen" href="./style.css" />
</head>

<body>
    <app-main>
    </app-main>
    <script src="./AppMain.js" type="module"></script>
</body>

</html>
EOF

cat << 'EOF' > AppMain.js
const template = document.createElement('template');

template.innerHTML = `
  <div>Hello World!</div>
`

export default class AppMain extends HTMLElement {
    constructor() {
        super();
        this._shadowRoot = this.attachShadow({ 'mode': 'open' });
        this._shadowRoot.appendChild(template.content.cloneNode(true));
    }

    connectedCallback() {
    }
}

window.customElements.define('app-main', AppMain);

EOF

cat << 'EOF' > style.css
:root {
  box-sizing: border-box;
}

*,
::before,
::after {
  box-sizing: inherit;
}
EOF

echo "Run ' browser-sync . -f . --single --cors --no-notify'."