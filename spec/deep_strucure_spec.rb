require 'spec_helper'

RSpec.describe APIConfig::DeepStruct do
  let!(:hash) { { a: :a, b: { c: { d: :e }}} }

  subject { APIConfig::DeepStruct.new(hash, 'src') }

  describe '#to_h' do
    it 'works' do
      expect(subject.to_h).to eq(hash)
    end
  end

  describe '#path_for' do
    it 'works' do
      expect(subject.path_for(:a)).to     eq("#{APIConfig.env}.a")
      expect(subject.b.c.path_for(:d)).to eq("#{APIConfig.env}.b.c.d")
    end
  end

  describe '#method_missing' do
    it 'works' do
      expect(subject.a).to     eq(:a)
      expect(subject.b.c.d).to eq(:e)
      expect(subject.b.c).to   eq(described_class.new(d: :e))
      expect(subject.c).to     eq(nil)
    end

    it 'works with !' do
      expect(subject.a!).to       eq(:a)
      expect(subject.b!.c!.d!).to eq(:e)
      expect(subject.b!.c!).to    eq(described_class.new(d: :e))
      expect{subject.c!}.to       raise_error("API Setting `test.c' not found in src")
    end
  end
end
