.PHONY: all

ENTRYPOINT = src
TEST_ENTRYPOINT = .

format:
	cairo-format -r $(ENTRYPOINT)

test:
	cairo-test $(TEST_ENTRYPOINT)