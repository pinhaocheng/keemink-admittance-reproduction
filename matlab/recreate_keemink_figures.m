function output_paths = recreate_keemink_figures(target)
%RECREATE_KEEMINK_FIGURES Generate selected MATLAB recreations from the paper.

arguments
    target string = "fig06a"
end

all_targets = ["fig06a","fig07a","fig07b","fig08","fig09a","fig10a","fig11a","fig12","fig13a","fig15a"];

targets = lower(string(target));
if any(targets == "all")
    targets = all_targets;
end

output_paths = strings(0, 1);
for current_target = targets(:).'
    switch current_target
        case "fig06a"
            output_paths(end + 1, 1) = keemink.makeFigure6a(); 
        case "fig07a"
            output_paths(end + 1, 1) = keemink.makeFigure7a(); 
        case "fig07b"
            output_paths(end + 1, 1) = keemink.makeFigure7b(); 
        case "fig08"
            output_paths(end + 1, 1) = keemink.makeFigure8(); 
        case "fig09a"
            output_paths(end + 1, 1) = keemink.makeFigure9a(); 
        case "fig10a"
            output_paths(end + 1, 1) = keemink.makeFigure10a(); 
        case "fig11a"
            output_paths(end + 1, 1) = keemink.makeFigure11a(); 
        case "fig12"
            output_paths(end + 1, 1) = keemink.makeFigure12(); 
        case "fig13a"
            output_paths(end + 1, 1) = keemink.makeFigure13a(); 
        case "fig15a"
            output_paths(end + 1, 1) = keemink.makeFigure15a();
        otherwise
            error("Unsupported target '%s'. Supported: %s, all.", ...
                current_target, join(all_targets, ", "));
    end
end

disp("Generated files:");
disp(output_paths);
end
