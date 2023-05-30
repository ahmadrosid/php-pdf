<?php

$size = php_pdf_get_page_size('2303.12712.pdf');
echo $size;

$text = php_pdf_read_page('2303.12712.pdf', 100);
echo $text;

$texts = php_pdf_read_all('2303.12712.pdf');
foreach ($texts as $text) {
    echo $text;
}
