dataset = 'simple_model_synt50_gaussi_compare_data1';
load( fullfile(pwd, 'Data', 'synt',[dataset '.mat']));

[qI_integrals, aI_integrals]=calc_instensity_integrals(data, model);

pd = makedist('Exponential');
qqplot(qI_integrals*1,pd);
figure;
qqplot(aI_integrals,pd);
