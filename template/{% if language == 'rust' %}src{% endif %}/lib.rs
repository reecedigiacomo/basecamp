pub fn greet(name: &str) -> String {
    format!("Hello, {name}!")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn greet_includes_the_name() {
        assert_eq!(greet("Ada"), "Hello, Ada!");
    }
}
