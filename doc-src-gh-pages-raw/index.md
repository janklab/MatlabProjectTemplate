---
layout: default
---

MailSpoon is a Matlab library for generating advanced emails using HTML and MIME capabilities. It supports HTML email, inline images, file attachments, Cc and Bcc addresses, SMTP server configuration, and more. It is suitable for server-side automation of email generation.

MailSpoon can be used to produce nice reports, error notifications, or whatever else you want to use fancy emails for.

MailSpoon is written in a modern Matlab style. It's my goal to make MailSpoon an example of how nice Matlab libraries can be organized.

## Requirements

* Matlab R2019b or newer

## Installation

To install MailSpoon:

* Download the MailSpoon [repo](https://github.com/janklab/MailSpoon).
* Add its `Mcode` directory to your Matlab path using `addpath()`.

## Usage

The main interface for building and sending email is `mailspoon.HtmlEmail`. You create an email object, add text and attachments, and then send it.

```matlab
e = mailspoon.HtmlEmail;
e.from = 'Alice Foo <alice@example.com>';
e.to = ["bob@example.com", "Carol Bar <carol@example.com>"];
e.subject = 'Hello, World!';

% Set HTML using setHtmlMsg()
e.html = strjoin({
  '<html><body>'
  '<h1>Hello, World!</h1>'
  ''
  '<p>This is a message sent from '
  '  <a href="http://github.com/janklab/MailSpoon"><b>MailSpoon</b></a> '
  'for MATLAB®.</p>'
  ''
  '</html></body>'
  }, '\n');

% Attach files using attach()
e.attach([mfilename('fullpath') '.m'])

% Now send it!
e.send
```

### Inline images

To incorporate inline images into your HTML message, you need to "embed" them into the message first in order to get "cid" identifiers for them, and then stick those cids into your HTML inside `<img>` tags.

```matlab
e = mailspoon.HtmlEmail('to@example.com', 'Me <from@example.com>');
e.subject = 'Look at these inline images from MailSpoon!';

% Embed images first, to get their cids

fig = figure('Visible','off');
surf(peaks);
fig_cid = e.embed(fig);
close(fig);

file = fullfile(mailspoon.libinfo.distroot, 'scratch', 'Brooklyn.jpg');
file_cid = e.embed(file);

% Then create your HTML using those cids

e.html = sprintf(strjoin({
  '<html>'
  '<body>'
  '<h1>Hello, World!</h1>'
  ''
  '<h2>A Matlab Figure</h2>'
  '<img src=cid:%s>'  % Do not put a "/" in the img tag!
  ''
  '<h2>An Image File</h2>'
  '<img src=cid:%s>'
  ''
  '<p>This is a message sent from '
  '<a href="http://github.com/janklab/MailSpoon"><b>MailSpoon</b></a> '
  'for MATLAB®.</p>'
  ''
  '</html>'
  '</body>'
  }, '\n'), fig_cid, file_cid);

e.send
```

### Generating HTML from data

MailSpoon includes functions for rendering data (such as Matlab `table` arrays) as HTML, for inclusion in your email. The main interface for that is the `mailspoon.htmlify` function.

```matlab
tbl = array2table(magic(5));
htmlFragment = mailspoon.htmlify(tbl);
html = sprintf(strjoin({
  '<html><body>'
  '<h1>Here is a table</h1>'
  '  %s'
  '</body></html>'
  }, '\n'), htmlFragment);
```

### Example

If all goes well, you'll soon be sending emails that look like this!

![Screenshot of MailSpoon email message](examples/MailSpoon-message-screenshot.png)

### SMTP server configuration

Email server configuration is done through the `mailspoon.MailHost` interface. Grab the default SMTP server configuration from `mailspoon.MailHost.default` and set its properties.

```matlab
host = mailspoon.MailHost.default;
host.username = 'my_smtp_username';
host.password = 'my_password';
% If your mail host requires SSL
host.useSsl = true;
host.sslPort = 9999; % If they don't use the default port 465
```

For settings that you don't configure in `mailspoon.MailHost`, MailSpoon will fall back to the defaults found in Matlab's `Internet` prefs, Java system properties, and maybe other places if I can find a reasonable way to look them up.

Configuring `mailspoon.MailHost.default` is local to the Matlab session, and does not cause the Matlab preferences file to be updated, the way `setpref('Internet')` does. This makes it suitable for use in automated processes on the server side.

### Debugging

If you want to see debugging dumps of the internals of the objects, call `inspect()` on them.

```matlab
e.inspect
```

## Technology

MailSpoon is built on top of [Apache Commons Email](https://commons.apache.org/proper/commons-email/) and [JavaMail/`javax.mail`](https://javaee.github.io/javamail/).

## Author

MailSpoon was written by [Andrew Janke](https://apjanke.net).

The project home page is the [GitHub repo page](https://github.com/janklab/MailSpoon). Bug reports and feature requests are welcome.

MailSpoon is part of the [Janklab](https://janklab.net) suite of libraries for Matlab.

MailSpoon's basic functionality is based on [this post](https://undocumentedmatlab.com/articles/sending-html-emails-from-matlab) from Yair Altman at [Undocumented Matlab](https://undocumentedmatlab.com/).

Thank you to [BAND-MAID](https://www.youtube.com/channel/UCJToUvYrmkmTCR-bluEaQfA) and [Lovebites](https://www.facebook.com/LovebitesTheBand/) for powering my coding.
