figure();
hold on
a = ones(1000, 1);

l1 = conv(a, importdata('20180316room_lens1.dat'));
l2 = conv(a, importdata('20180316room_lens2.dat'));
l3 = conv(a, importdata('20180316room_lens3.dat'));
p1 = conv(a, importdata('20180316room_no1.dat'  ));
p2 = conv(a, importdata('20180316room_no2.dat'  ));
p3 = conv(a, importdata('20180316room_no3.dat'  ));

zerol1 = l1(60000:180000);
zerol2 = l2(60000:180000);
zerol3 = l3(60000:180000);
zerop1 = p1(60000:180000);
zerop2 = p2(60000:180000);
zerop3 = p3(60000:180000);

avgl1 = mean(zerol1);
avgl2 = mean(zerol2);
avgl3 = mean(zerol3);
avgp1 = mean(zerop1);
avgp2 = mean(zerop2);
avgp3 = mean(zerop3);


lightl1 = l1(500000:620000);
lightl2 = l2(500000:620000);
lightl3 = l3(500000:620000);
lightp1 = p1(500000:620000);
lightp2 = p2(500000:620000);
lightp3 = p3(500000:620000);


plot(zerol1 - avgl1, 'b-');
plot(zerol2 - avgl2, 'b-');
plot(zerol3 - avgl3, 'b-');
plot(zerop1 - avgp1, 'r-');
plot(zerop2 - avgp2, 'r-');
plot(zerop3 - avgp3, 'r-');

plot(lightl1 - avgl1, 'b-');
plot(lightl2 - avgl2, 'b-');
plot(lightl3 - avgl3, 'b-');
plot(lightp1 - avgp1, 'r-');
plot(lightp2 - avgp2, 'r-');
plot(lightp3 - avgp3, 'r-');



l = [mean(lightl1 - avgl1) mean(lightl2 - avgl2) mean(lightl3 - avgl3)]
p = [mean(lightp1 - avgp1) mean(lightp2 - avgp2) mean(lightp3 - avgp3)]
