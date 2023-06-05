## PHP Pdf reader

PHP Extension for reading pdf document written in Rust. This extension is using [mupdf-rs](https://github.com/messense/mupdf-rs) to parsing the pdf file.

## Build

Before you build install this package on linux:

```bash
sudo apt install software-properties-common libfontconfig1-dev mupdf-tools gperf clang php8.1-dev build-essential autoconf unzip
```

Or for other linux distribution:

- Alpine Linux: `fontconfig-dev`
- Arch Linux: `fontconfig`
- Debian-based systems: `libfontconfig1-dev`
- FreeBSD: `fontconfig`
- Void Linux: `fontconfig-devel`

Run this command to build debug version:

```bash
cargo build
cp target/debug/libphp_pdf.dylib target/debug/libphp_pdf.so
```

Or you can use this bash script.

```bash
bash build.sh
```

Then you can use the debug version using this command.

```bash
php -d "extension=target/debug/libphp_pdf.so" test.php
```

### Release build

To build production release.

```bash
cargo build --release
cp target/release/libphp_pdf.dylib target/release/libphp_pdf.so
```

Then copy the extension to your extension dir for example here is my directory extension `/opt/homebrew/lib/php/pecl/20210902`, you can find the extension directory by runnig this command.

```bash
php -i | grep extension_dir
```

Then copy to that extension directory:

```bash
cp target/release/libphp_pdf.so /opt/homebrew/lib/php/pecl/20210902
```

Enable extension config ono `php.ini`:

```ini
extension=/opt/homebrew/lib/php/pecl/20210902/libphp_pdf.so
```

And now you are ready to go.

## Usage

Download example pdf document:

```bash
wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3"  https://arxiv.org/pdf/2303.12712.pdf
```

Get page size:

```php
$size = php_pdf_get_page_size('2303.12712.pdf');
echo $size;
```

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
