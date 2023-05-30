<?php

// $texts = php_pdf_read_all('2303.12712.pdf');
$text = php_pdf_read_page('2303.12712.pdf', 100);
echo $text;
// var_dump($texts);

// foreach ($texts as $text) {
//     echo $text;
// }
