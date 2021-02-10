function PlotElectVol_single_slice_all(elecMatrix, elecRgb, V,elecId, all_labels, slice)




mri.vol = V;
mx=max(max(max(mri.vol)))*.7;
mn=min(min(min(mri.vol)));
sVol=size(mri.vol);

xyz(:,1)=elecMatrix(:,2);
xyz(:,2)=elecMatrix(:,1);
xyz(:,3)=sVol(3)-elecMatrix(:,3);


font_size_label = 10;
marker_size = 40;
slice2d_axes(1) = subplot(1,1,1);


slice2d_axes(1) = subplot(1,1,1);
set(gcf, 'Position',   [0 0 .7 .8], 'units', 'Normalized')
switch slice
    case 'coronal'
        coords = [2, 1];
        slice_num_coord = 3;
        imshow(squeeze(mri.vol(:,:,xyz(elecId,3)))',[mn mx],'parent',slice2d_axes(1));
    case 'saggital'
        coords = [3, 1];
        slice_num_coord = 2;
        imshow(squeeze(mri.vol(xyz(elecId,2),:,:)),[mn mx],'parent',slice2d_axes(1));
    case 'horizontal'
        coords = [3, 2];
        slice_num_coord = 1;
        imshow(squeeze(mri.vol(:,xyz(elecId,1),:)),[mn mx],'parent',slice2d_axes(1));
        
end
set(gcf, 'Position',   [0 0 .7 .8], 'units', 'Normalized')
hold on

elecs = find(xyz(:,slice_num_coord) == xyz(elecId,slice_num_coord));
if ~isempty(elecs)
    hold on
    for io = 1:length(elecs)
        ioo = elecs(io);
        plot(xyz(ioo,coords(1)),xyz(ioo,coords(1)),'.','color',elecRgb(ioo,:),'markersize',marker_size,'parent',slice2d_axes(1));
        text(xyz(ioo,coords(1)),xyz(ioo,coords(1)), all_labels{ioo}, 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Top', 'FontSize', font_size_label, 'Color', elecRgb(ioo,:), 'parent',slice2d_axes(1))
    end
else
end

switch slice
    case 'horizontal'
        
        
        axis(slice2d_axes(1),'square');
        mxX=max(squeeze(mri.vol(xyz(elecId,2),:,:)),[],2);
        mxY=max(squeeze(mri.vol(xyz(elecId,2),:,:)),[],1);
        limXa=max(intersect(1:(sVol(3)/2),find(mxX==0)));
        limXb=min(intersect((sVol(3)/2:sVol(3)),find(mxX==0)));
        limYa=max(intersect(1:(sVol(1)/2),find(mxY==0)));
        limYb=min(intersect((sVol(1)/2:sVol(1)),find(mxY==0)));
        %keep image square
        centershift = sVol(3)/2-((limXb-limXa)/2+limXa);
        if limYa-(limYb-limYa) < limYb+(limYb-limYa)
            axis(slice2d_axes(1),[limYa-(limYb-limYa)*0.05 limYb+(limYb-limYa)*0.05...
                limYa-(limYb-limYa)*0.05-centershift limYb+(limYb-limYa)*0.05-centershift ])
        end
        % tempMin=min([limXa limYa]);
        % tempMax=max([limXb limYb]);
        % if tempMin<tempMax
        %     axis([tempMin tempMax tempMin tempMax]);
        % end
        set(slice2d_axes(1),'xtick',[],'ytick',[]);
        
    case 'saggital'
        
        axis(slice2d_axes(1),'square');
        set(slice2d_axes(1),'xdir','reverse');
        mxX=max(squeeze(mri.vol(:,xyz(elecId,1),:)),[],2);
        mxY=max(squeeze(mri.vol(:,xyz(elecId,1),:)),[],1);
        limXa=max(intersect(1:(sVol(3)/2),find(mxX==0)));
        limXb=min(intersect((sVol(3)/2:sVol(3)),find(mxX==0)));
        limYa=max(intersect(1:(sVol(2)/2),find(mxY==0)));
        limYb=min(intersect((sVol(2)/2:sVol(2)),find(mxY==0)));
        %keep image square
        tempMin=min([limXa limYa]);
        tempMax=max([limXb limYb]);
        if tempMin<tempMax
            axis(slice2d_axes(1),[tempMin tempMax tempMin tempMax]);
        end
        set(slice2d_axes(1),'xtick',[],'ytick',[],'xdir','reverse');
        
    case 'coronal'
        
        
        axis(slice2d_axes(1),'square');
        mxX=max(squeeze(mri.vol(:,:,xyz(elecId,3))),[],2);
        mxY=max(squeeze(mri.vol(:,:,xyz(elecId,3))),[],1);
        limXa=max(intersect(1:(sVol(3)/2),find(mxX==0)));
        limXb=min(intersect((sVol(3)/2:sVol(3)),find(mxX==0)));
        limYa=max(intersect(1:(sVol(2)/2),find(mxY==0)));
        limYb=min(intersect((sVol(2)/2:sVol(2)),find(mxY==0)));
        %keep image square
        centershift = sVol(3)/2-((limYb-limYa)/2+limYa);
        if limXa-(limXb-limXa) < limXb+(limXb-limXa)
            axis(slice2d_axes(1),[limXa-(limXb-limXa)*0.07 limXb+(limXb-limXa)*0.07...
                limXa-(limXb-limXa)*0.07-centershift limXb+(limXb-limXa)*0.07-centershift ])
        end
        
end

set(slice2d_axes(1),'xtick',[],'ytick',[],'xdir','reverse');