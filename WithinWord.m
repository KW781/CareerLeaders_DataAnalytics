function [is_within] = WithinWord(small_word, large_word)
    is_within = 0;
    if length(small_word) <= length(large_word)
        small_word = lower(small_word);
        large_word = lower(large_word);
        for i = 1 : length(large_word) - length(small_word) + 1
            is_within = 1;
            for j = 1 : length(small_word)
                if small_word(j) ~= large_word(i + j - 1)
                    is_within = 0;
                    break;
                end
            end
            if is_within
                break;
            end
        end
    end
end