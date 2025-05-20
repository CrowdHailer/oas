import gleeunit/should
import oas/path_template.{Fixed, Variable}

pub fn must_start_with_slash_test() {
  path_template.parse("")
  |> should.be_error
  path_template.parse("https://example.com")
  |> should.be_error
}

pub fn fixed_segments_test() {
  path_template.parse("/biscuit/jam")
  |> should.be_ok
  |> should.equal([Fixed("biscuit"), Fixed("jam")])
}

pub fn invalid_fixed_segments_test() {
  path_template.parse("/somthing{}/else")
  |> should.be_error
}

pub fn variable_segments_test() {
  path_template.parse("/{foo}/jam/{bar}")
  |> should.be_ok
  |> should.equal([Variable("foo"), Fixed("jam"), Variable("bar")])
}

pub fn ignore_query_test() {
  path_template.parse("/cake?topping=no")
  |> should.be_ok
  |> should.equal([Fixed("cake")])
}

pub fn ignore_hash_test() {
  path_template.parse("/tea#time")
  |> should.be_ok
  |> should.equal([Fixed("tea")])
}
