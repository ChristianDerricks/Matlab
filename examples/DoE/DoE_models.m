% This file needs the perms and permn function and
% of course some files from the pkg repository

function DoE_models()

  initialize(); 
  color = colorlist();
 
  number_of_figures = 6;
  number_of_axes    = 1;

  config = create_figures_and_load_saved_position(number_of_figures, number_of_axes);

  % settings are made for high quality tikz figures
  tikz = tikzoptions();
  tikz.texfilename = 'DoE';
  tikz.xprecision = 0;
  tikz.yprecision = 0;
  tikz.sloped      = 1;
  tikz.set_noSize  = true;
  tikz.axisheight  = '10cm';
  tikz.axiswidth   = '10cm';

  tikz.makelegend       = 1; % only for figure 1, there is a switch in the general settings part below
  tikz.legend           = 'CCC, ICC, FCC, FF, BB';
  tikz.legendpos        = '0,0.846';
  tikz.legendalign      = 'left';
  tikz.legendanchor     = 'north west';  
  
  markersize   = 15;
  CPmarkersize = 25;
  linewidth    =  1; % red dotted lines
  linewidthbox =  1; % blue dotted box (not the frame)

  show_sphere =  0;  

  k = 3;
  alpha = (2^k)^(1/4);
  [p,q,r] = meshgrid([-1 0 1], [-1 0 1], [-1 0 1]);
  dFF = [p(:) q(:) r(:)]; 

  cccd = circumscribed_central_composite_design(alpha);
  iccd = inscribed_central_composite_design();
  fccd = faced_central_composite_design();
  bbd = box_behnken_design();

  % overlapping position makrking for the different models
  scatter3(config{1}.ax(1), cccd(:,1),cccd(:,2),cccd(:,3), 25, 'MarkerFaceColor', color{1},'MarkerEdgeColor','none');
  scatter3(config{1}.ax(1), iccd(:,1),iccd(:,2),iccd(:,3), 20, 'MarkerFaceColor', color{2},'MarkerEdgeColor','none');
  scatter3(config{1}.ax(1), fccd(:,1),fccd(:,2),fccd(:,3), 15, 'MarkerFaceColor', color{3},'MarkerEdgeColor','none');
  scatter3(config{1}.ax(1), dFF(:,1),dFF(:,2),dFF(:,3),    10, 'MarkerFaceColor', color{4},'MarkerEdgeColor','none');
  scatter3(config{1}.ax(1), bbd(:,1),bbd(:,2),bbd(:,3),    5, 'MarkerFaceColor',  color{5},'MarkerEdgeColor','none');

  % blue dotted big cube
  X = [1  1  1  1  1 -1  1 -1  1  1 -1 -1; -1 -1 -1 -1  1 -1  1 -1 1  1 -1 -1];
  Y = [1  1 -1 -1  1 -1 -1  1 -1 -1  1  1;  1  1 -1 -1  1 -1 -1  1 1  1 -1 -1];
  Z = [1 -1  1 -1  1  1  1  1  1 -1  1 -1;  1 -1  1 -1 -1 -1 -1 -1 1 -1  1 -1];

  % red dotted lines
  xcentralfull = [0 1 0;  0 -1  0];
  ycentralfull = [1 0 0; -1  0  0];
  zcentralfull = [0 0 1;  0  0 -1];

  % star like center point connections for bbd
  xbbd = [1  1  0  0 1  1; -1 -1  0  0 -1 -1];
  ybbd = [1 -1  1 -1 0  0; -1  1 -1  1  0  0];
  zbbd = [0  0  1  1 1 -1;  0  0 -1 -1 -1  1];

  % ======================================================================

  line(    config{2}.ax(1), xcentralfull*alpha,ycentralfull*alpha,zcentralfull*alpha, 'LineWidth', linewidth, 'Color', color{5}, 'LineStyle', '--');
  scatter3(config{2}.ax(1), cccd(:,1),cccd(:,2),cccd(:,3), markersize, 'MarkerFaceColor', color{2}, 'MarkerEdgeColor', color{2});
  title(   config{2}.ax(1), 'circumscribed central composite design (cccd)');

  % ======================================================================

  line(    config{3}.ax(1), xcentralfull,ycentralfull,zcentralfull, 'LineWidth', linewidth, 'Color', color{5}, 'LineStyle', '--');
  line(    config{3}.ax(1), X*(1/alpha),Y*(1/alpha),Z*(1/alpha), 'LineWidth', linewidth, 'Color', color{2}, 'LineStyle', '--');
  scatter3(config{3}.ax(1), iccd(:,1),iccd(:,2),iccd(:,3), markersize, 'MarkerFaceColor', color{2},'MarkerEdgeColor', color{2});
  title(   config{3}.ax(1), 'inscribed central composite design (iccd)');

  % ======================================================================

  line(    config{4}.ax(1), xcentralfull,ycentralfull,zcentralfull, 'LineWidth', linewidth,'Color',color{5}, 'LineStyle', '--');
  scatter3(config{4}.ax(1), fccd(:,1),fccd(:,2),fccd(:,3), markersize, 'MarkerFaceColor',color{2}, 'MarkerEdgeColor', color{2});
  title(   config{4}.ax(1), 'faced central composite design (fccd)');

  % ======================================================================
  
  line(    config{5}.ax(1), xbbd,ybbd,zbbd, 'LineWidth', linewidth,'Color', color{5}, 'LineStyle', '--');
  scatter3(config{5}.ax(1), bbd(:,1),bbd(:,2),bbd(:,3), markersize, 'MarkerFaceColor', color{2}, 'MarkerEdgeColor', color{2});
  title(   config{5}.ax(1), 'Box–Behnken design (bbd)');

  % ======================================================================

  line(    config{6}.ax(1), xcentralfull,ycentralfull,zcentralfull, 'LineWidth', linewidth,'Color',color{5}, 'LineStyle', '--');
  scatter3(config{6}.ax(1), dFF(:,1),dFF(:,2),dFF(:,3), markersize, 'MarkerFaceColor', color{2},'MarkerEdgeColor', color{2});
  title(   config{6}.ax(1), 'full factorial design (ffd)');

  % ======================================================================

  r = 1.75;
  for idx = 1:number_of_figures
    box(config{idx}.ax(1), 'on');
    grid(config{idx}.ax(1), 'on');
    view(config{idx}.ax(1), -40, 20);
    xlim(config{idx}.ax(1), [-r r]);
    ylim(config{idx}.ax(1), [-r r]);
    zlim(config{idx}.ax(1), [-r r]);
    xlabel(config{idx}.ax(1), 'Parameter X' ,'rotation',  13);
    ylabel(config{idx}.ax(1), 'Parameter Y' ,'rotation', -32);
    zlabel(config{idx}.ax(1), 'Parameter Z');
    if is_octave()
      set(config{idx}.ax(1), 'xtick', [1 0 -1]);
      set(config{idx}.ax(1), 'ytick', [1 0 -1]);
      set(config{idx}.ax(1), 'ztick', [1 0 -1]);
    end
    % dotted box around the outer edges
    line(config{idx}.ax(1),     X, Y, Z,    'LineWidth', linewidthbox, 'Color', color{2}, 'LineStyle', '--');
    % center point
    if idx >= 2
      scatter3(config{idx}.ax(1), 0, 0, 0, CPmarkersize, 'MarkerFaceColor', color{4}, 'MarkerEdgeColor', color{4});
    end
    legend(config{idx}.ax(1), 'off');
  end

  for idx = 1:number_of_figures
    if idx >= 2
      tikz.makelegend = 0;
    end    
    m2t_export(config{idx}.ax(1), config{idx}.fig(idx), tikz.texfilename, num2str(idx), tikz);
  end
  save_all_images_in_one_tex_file(tikz.texfilename, number_of_figures);
end
