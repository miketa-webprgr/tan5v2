shared_examples "a protected admin controller" do |controller|
  let(:args) do
    { controller: controller}
  end

 describe "#index" do
   example "rootにリダイレクト" do
     get url_for(args.merge(action: :index))
     expect(response).to redirect_to(:root)
   end
 end
 describe "#show" do
   example "rootにリダイレクト" do
     get url_for(args.merge(action: :show, id: 2))
     expect(response).to redirect_to(:root)
   end
 end
end

