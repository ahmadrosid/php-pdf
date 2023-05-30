## PHP Pdf reader

Example download pdf:

```bash
wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3"  https://arxiv.org/pdf/2303.12712.pdf
```

## Build

Run this command to build debug version:

```bash
cargo build
cp target/debug/libphp_pdf.dylib target/debug/libphp_pdf.so
```

Or you can use this bash script.

```bash
bash build.sh
```

To build production release.

```bash
cargo build --release
cp target/release/libphp_pdf.dylib target/release/libphp_pdf.so
```

Then copy the extension to your extension dir for example here is my directory extension `/opt/homebrew/lib/php/pecl/20210902`:

```bash
cp target/release/libphp_pdf.so /opt/homebrew/lib/php/pecl/20210902
```

Enable extension config ono `php.ini`:

```ini
extension=/opt/homebrew/lib/php/pecl/20210902/libphp_pdf.so
```

And now you are ready to go.

## Usage

Read all document page texts.

```php
$texts = php_pdf_read_all('2303.12712.pdf');

foreach ($texts as $text) {
    echo $text;
}
```

Read document page by the page number.

```php
$text = php_pdf_read_page('2303.12712.pdf', 100);
echo $text;
```
