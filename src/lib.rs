use mupdf::pdf::PdfDocument;
use phper::{
    arrays::{InsertKey, ZArray},
    functions::Argument,
    modules::Module,
    php_get_module,
    values::ZVal,
};

fn php_pdf_read_all(arguments: &mut [ZVal]) -> phper::Result<ZArray> {
    let path = arguments[0].expect_z_str()?.to_str()?;
    let mut texts = ZArray::new();

    let document = PdfDocument::open(path).map_err(|err| phper::Error::Boxed(err.into()))?;
    let count = document
        .page_count()
        .map_err(|err| phper::Error::Boxed(err.into()))?;

    for i in 0..count {
        let page = document
            .load_page(i)
            .map_err(|err| phper::Error::Boxed(err.into()))?;
        let text = page
            .to_text()
            .map_err(|err| phper::Error::Boxed(err.into()))?;
        texts.insert(InsertKey::Index(i as u64), text);
    }

    Ok(texts)
}

fn php_pdf_read_page(arguments: &mut [ZVal]) -> phper::Result<String> {
    let path = arguments[0].expect_z_str()?.to_str()?;
    let page_number = arguments[1].expect_long()?;
    let document = PdfDocument::open(path).map_err(|err| phper::Error::Boxed(err.into()))?;
    let count = document
        .page_count()
        .map_err(|err| phper::Error::Boxed(err.into()))?;
    if (page_number as i32) >= count {
        return Err(phper::Error::Boxed("invalid page number".into()));
    }

    let page = document
        .load_page(page_number as i32)
        .map_err(|err| phper::Error::Boxed(err.into()))?;
    let text = page
        .to_text()
        .map_err(|err| phper::Error::Boxed(err.into()))?;
    Ok(text.into())
}

fn php_pdf_get_page_size(arguments: &mut [ZVal]) -> phper::Result<i64> {
    let path = arguments[0].expect_z_str()?.to_str()?;
    let document = PdfDocument::open(path).map_err(|err| phper::Error::Boxed(err.into()))?;
    let count = document
        .page_count()
        .map_err(|err| phper::Error::Boxed(err.into()))?;
    Ok(count as i64)
}

#[php_get_module]
pub fn get_module() -> Module {
    let mut module = Module::new(
        env!("CARGO_CRATE_NAME"),
        env!("CARGO_PKG_VERSION"),
        env!("CARGO_PKG_AUTHORS"),
    );

    module
        .add_function("php_pdf_read_all", php_pdf_read_all)
        .argument(Argument::by_val("path"));

    module
        .add_function("php_pdf_read_page", php_pdf_read_page)
        .argument(Argument::by_val("path"));

    module
        .add_function("php_pdf_get_page_size", php_pdf_get_page_size)
        .argument(Argument::by_val("path"));

    module
}
