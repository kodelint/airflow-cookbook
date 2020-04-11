# InSpec test for recipe airflow-cookbook::bootstrap

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('airflow-user'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(8080), :skip do
  it { should_not be_listening }
end
