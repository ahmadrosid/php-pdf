use lopdf::Document;
use phper::{
    arrays::{InsertKey, ZArray},
    functions::Argument,
    modules::Module,
    php_get_module,
    values::ZVal,
};

fn php_pdf_read_all(arguments: &mut [ZVal]) -> phper::Result<ZArray> {
    let path = arguments[0].expect_z_str()?.to_str()?;
    let doc: Result<Document, lopdf::Error> = Document::load(path);
    match doc {
        Ok(document) => {
            let pages = document.get_pages();
            let mut texts = ZArray::new();

            for (i, _) in pages.iter().enumerate() {
                let page_number = (i + 1) as u32;
                let text = document.extract_text(&[page_number]);
                texts.insert(
                    InsertKey::Index(page_number as u64),
                    text.unwrap_or_default(),
                );
            }
            Ok(texts)
        }
        Err(err) => Err(phper::Error::Boxed(err.into())),
    }
}

fn php_pdf_read_page(arguments: &mut [ZVal]) -> phper::Result<String> {
    let path = arguments[0].expect_z_str()?.to_str()?;
    let page = arguments[1].expect_long()?;
    let doc = Document::load(path);
    match doc {
        Ok(document) => {
            let pages = document.get_pages();
            if page >= pages.len() as i64 {
                return Err(phper::Error::Boxed("invalid page number".into()));
            }
            let text = document.extract_text(&[page as u32]);
            Ok(text.unwrap().to_string())
        }
        Err(err) => Err(phper::Error::Boxed(err.into())),
    }
}

fn php_pdf_get_page_size(arguments: &mut [ZVal]) -> phper::Result<i64> {
    let path = arguments[0].expect_z_str()?.to_str()?;
    let doc = Document::load(path);
    match doc {
        Ok(document) => {
            let pages = document.get_pages();
            Ok(pages.len().try_into().unwrap())
        }
        Err(err) => Err(phper::Error::Boxed(err.into())),
    }
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
