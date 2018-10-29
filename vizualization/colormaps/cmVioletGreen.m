function map = cmVioletGreen(m)
%RED BLUE colormap

if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

values = [
 0.5362 0.2942 0.5950
 0.5400 0.3043 0.6000
 0.5438 0.3143 0.6049
 0.5476 0.3243 0.6097
 0.5513 0.3342 0.6145
 0.5549 0.3440 0.6192
 0.5586 0.3536 0.6239
 0.5623 0.3632 0.6286
 0.5660 0.3726 0.6333
 0.5699 0.3819 0.6380
 0.5738 0.3909 0.6427
 0.5779 0.3998 0.6474
 0.5821 0.4085 0.6521
 0.5865 0.4169 0.6569
 0.5911 0.4251 0.6617
 0.5959 0.4331 0.6666
 0.6010 0.4407 0.6716
 0.6063 0.4483 0.6766
 0.6115 0.4557 0.6816
 0.6168 0.4631 0.6866
 0.6222 0.4705 0.6916
 0.6275 0.4778 0.6966
 0.6329 0.4851 0.7015
 0.6383 0.4923 0.7065
 0.6438 0.4995 0.7115
 0.6492 0.5066 0.7165
 0.6547 0.5137 0.7215
 0.6602 0.5208 0.7264
 0.6657 0.5278 0.7313
 0.6712 0.5348 0.7362
 0.6767 0.5417 0.7411
 0.6822 0.5486 0.7459
 0.6877 0.5555 0.7507
 0.6931 0.5624 0.7555
 0.6986 0.5692 0.7603
 0.7041 0.5760 0.7649
 0.7095 0.5827 0.7696
 0.7150 0.5894 0.7742
 0.7204 0.5962 0.7788
 0.7257 0.6028 0.7833
 0.7311 0.6095 0.7877
 0.7364 0.6161 0.7921
 0.7417 0.6227 0.7964
 0.7469 0.6293 0.8006
 0.7521 0.6359 0.8048
 0.7572 0.6425 0.8089
 0.7623 0.6490 0.8130
 0.7674 0.6556 0.8169
 0.7726 0.6621 0.8209
 0.7779 0.6687 0.8248
 0.7831 0.6752 0.8286
 0.7885 0.6818 0.8324
 0.7938 0.6883 0.8362
 0.7992 0.6949 0.8399
 0.8045 0.7014 0.8435
 0.8099 0.7079 0.8471
 0.8153 0.7144 0.8507
 0.8206 0.7208 0.8542
 0.8260 0.7272 0.8576
 0.8312 0.7336 0.8610
 0.8365 0.7400 0.8644
 0.8417 0.7463 0.8677
 0.8468 0.7526 0.8709
 0.8519 0.7588 0.8741
 0.8569 0.7650 0.8773
 0.8618 0.7711 0.8804
 0.8665 0.7771 0.8834
 0.8712 0.7831 0.8864
 0.8758 0.7890 0.8893
 0.8803 0.7949 0.8922
 0.8846 0.8006 0.8950
 0.8888 0.8063 0.8978
 0.8928 0.8119 0.9005
 0.8966 0.8175 0.9032
 0.9003 0.8229 0.9058
 0.9039 0.8282 0.9083
 0.9072 0.8335 0.9108
 0.9106 0.8388 0.9135
 0.9141 0.8443 0.9163
 0.9176 0.8499 0.9193
 0.9212 0.8556 0.9224
 0.9248 0.8614 0.9257
 0.9285 0.8672 0.9290
 0.9321 0.8731 0.9324
 0.9356 0.8790 0.9358
 0.9392 0.8848 0.9392
 0.9426 0.8907 0.9426
 0.9460 0.8965 0.9460
 0.9493 0.9022 0.9492
 0.9524 0.9078 0.9524
 0.9554 0.9133 0.9555
 0.9582 0.9187 0.9584
 0.9608 0.9240 0.9612
 0.9633 0.9290 0.9637
 0.9655 0.9339 0.9661
 0.9674 0.9385 0.9681
 0.9692 0.9429 0.9700
 0.9706 0.9470 0.9715
 0.9717 0.9509 0.9727
 0.9725 0.9545 0.9735
 0.9730 0.9577 0.9740
 0.9731 0.9606 0.9740
 0.9728 0.9631 0.9736
 0.9721 0.9652 0.9728
 0.9711 0.9669 0.9715
 0.9696 0.9682 0.9697
 0.9676 0.9690 0.9674
 0.9655 0.9696 0.9648
 0.9631 0.9701 0.9620
 0.9606 0.9704 0.9589
 0.9579 0.9705 0.9555
 0.9550 0.9704 0.9520
 0.9520 0.9702 0.9482
 0.9488 0.9699 0.9442
 0.9455 0.9694 0.9401
 0.9420 0.9688 0.9357
 0.9384 0.9681 0.9312
 0.9346 0.9672 0.9265
 0.9308 0.9663 0.9217
 0.9268 0.9652 0.9168
 0.9227 0.9641 0.9118
 0.9185 0.9629 0.9066
 0.9142 0.9616 0.9014
 0.9099 0.9603 0.8960
 0.9054 0.9588 0.8906
 0.9009 0.9574 0.8851
 0.8963 0.9559 0.8796
 0.8917 0.9544 0.8741
 0.8869 0.9528 0.8685
 0.8822 0.9512 0.8629
 0.8774 0.9496 0.8573
 0.8725 0.9480 0.8517
 0.8677 0.9464 0.8461
 0.8628 0.9449 0.8406
 0.8579 0.9433 0.8351
 0.8529 0.9418 0.8296
 0.8480 0.9403 0.8242
 0.8429 0.9387 0.8186
 0.8377 0.9370 0.8129
 0.8323 0.9352 0.8071
 0.8267 0.9334 0.8011
 0.8211 0.9314 0.7950
 0.8153 0.9294 0.7888
 0.8093 0.9273 0.7825
 0.8032 0.9251 0.7761
 0.7971 0.9228 0.7696
 0.7907 0.9204 0.7630
 0.7843 0.9179 0.7564
 0.7778 0.9154 0.7496
 0.7711 0.9128 0.7428
 0.7644 0.9101 0.7359
 0.7575 0.9073 0.7290
 0.7506 0.9044 0.7220
 0.7435 0.9015 0.7150
 0.7364 0.8984 0.7079
 0.7292 0.8953 0.7008
 0.7219 0.8921 0.6937
 0.7145 0.8889 0.6865
 0.7071 0.8855 0.6794
 0.6996 0.8821 0.6722
 0.6920 0.8786 0.6651
 0.6844 0.8750 0.6579
 0.6767 0.8714 0.6508
 0.6689 0.8677 0.6437
 0.6612 0.8639 0.6366
 0.6533 0.8600 0.6296
 0.6454 0.8560 0.6225
 0.6370 0.8519 0.6151
 0.6283 0.8475 0.6075
 0.6191 0.8430 0.5996
 0.6097 0.8384 0.5915
 0.5999 0.8335 0.5832
 0.5898 0.8285 0.5747
 0.5795 0.8233 0.5661
 0.5690 0.8180 0.5573
 0.5583 0.8126 0.5485
 0.5474 0.8070 0.5395
 0.5364 0.8012 0.5305
 0.5253 0.7954 0.5214
 0.5141 0.7894 0.5124
 0.5029 0.7834 0.5033
 0.4916 0.7772 0.4942
 0.4804 0.7709 0.4852
 0.4693 0.7645 0.4762
 0.4582 0.7581 0.4674
 0.4473 0.7515 0.4586
 0.4366 0.7450 0.4500
 0.4260 0.7383 0.4415
 0.4157 0.7316 0.4332
 0.4057 0.7248 0.4251
 0.3961 0.7180 0.4172
 0.3868 0.7112 0.4095
 0.3779 0.7044 0.4021
 0.3695 0.6975 0.3950
 0.3616 0.6906 0.3882
 0.3543 0.6837 0.3817
 0.3474 0.6768 0.3754
 0.3404 0.6699 0.3692
 0.3333 0.6629 0.3630
 0.3261 0.6559 0.3569
 0.3188 0.6489 0.3509
 0.3114 0.6418 0.3449
 0.3039 0.6347 0.3390
 0.2964 0.6275 0.3331
 0.2887 0.6204 0.3273
 0.2810 0.6132 0.3215
 0.2732 0.6060 0.3158
 0.2654 0.5988 0.3101
 0.2574 0.5916 0.3045
 0.2494 0.5844 0.2990
 0.2413 0.5772 0.2935];

P = size(values,1);
map = interp1(1:size(values,1), values, linspace(1,P,m), 'linear');