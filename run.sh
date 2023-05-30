#!/bin/bash

php -d "extension=target/debug/libphp_pdf.so" test.php
