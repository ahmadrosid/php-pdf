<?php

// $pdf_path = '2303.12712.pdf';
$pdf_path = "Ahmad Rosid Resume.pdf";

// $size = php_pdf_get_page_size($pdf_path);
// echo $size;

// $texts = php_pdf_read_all($pdf_path);
// foreach ($texts as $text) {
//     echo $text;
// }

$text = php_pdf_read_page($pdf_path, 2);
echo $text;
