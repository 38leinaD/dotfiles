#!/bin/bash
set -e

function single() {
  cat << 'EOF' > index.html
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>hello webstandards</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
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
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body>
    <app-main>
    </app-main>
    <div>test</div>

    <script type="module">
        import sheet from 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css' assert { type: 'css' };

        const template = document.createElement('template');

        template.innerHTML = `
        <i class="fa-solid fa-spinner fa-spin-pulse"></i>

        <div>Hello World!</div><i class="fa-solid fa-font-awesome"></i>
        `

        export default class AppMain extends HTMLElement {
            constructor() {
                super();
                this._shadowRoot = this.attachShadow({ 'mode': 'open' });
                this._shadowRoot.appendChild(template.content.cloneNode(true));
                this._shadowRoot.adoptedStyleSheets = [sheet];
            }

            connectedCallback() {
            }
        }

        window.customElements.define('app-main', AppMain);
    </script>
</body>

</html>
EOF
}

function seperated() {
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
}

if [ ! -z $1 ]; then 
    eval $1
else
    seperated
fi

echo "Run ' browser-sync . -f . --single --cors --no-notify'."