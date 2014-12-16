require 'spec_helper'

describe 'cmake#extension#syntastic' do
  describe '#inject' do
    before(:each) do
      cmake.create_new
      cmake.configure
      vim.command 'call cmake#targets#cache()'
    end

    context 'function existence' do
      it 'does exist when not called' do
        expect(function_exists? 'cmake#extension#syntastic#inject(args)').to eql(true)
      end

      it 'does exist when called' do
        vim.command 'call cmake#extension#syntastic#inject({"target":"sample-binary"})'
        expect(function_exists? 'cmake#extension#syntastic#inject(args)').to eql(true)
      end
    end

    it 'populates the buffers options' do
      vim.command 'call cmake#extension#syntastic#inject({"target":"sample-library"})'
      obtained_includes = validate_response 'echo b:syntastic_cpp_includes'
      expect(obtained_includes).to_not be_empty
      expect(obtained_includes).to_not include('[')
    end
  end
end
