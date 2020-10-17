
@mfunction("k1, k2, A, min, pos")
def make_roc(x=None):

    N = size(x, 1)
    xt = sort(x(mslice[:]))
    #     At=zeros(N,1);
    #     %clf;
    #     hold on;
    #     for j=1:length(xt);

    xt = mcat([xt, OMPCSEMI, xt(end) + 1])
    k1 = xt * nan
    k2 = xt * nan
    for i in mslice[1:length(xt)]:
        #             if i~=1
        #             xt(i)
        #             xt(i-1)
        #             pause
        #             end
        if (i == 1):
            k1(i).lvalue = sum(x(mslice[:], 1) >= xt(i))
            k2(i).lvalue = sum(x(mslice[:], 2) >= xt(i))
        elif xt(i) > xt(i - 1):
            k1(i).lvalue = sum(x(mslice[:], 1) >= xt(i))
            k2(i).lvalue = sum(x(mslice[:], 2) >= xt(i))
        end

    end
    # keyboard

    k1 = k1(not isnan(k1))
    k2 = k2(not isnan(k2))
    k1 = k1 / N
    k2 = k2 / N
    # A=-sum(diff(k1).*k2(1:end-1));
    A = 0
    for i in mslice[2:length(k1)]:
        A = A - (k1(i) - k1(i - 1)) * (k2(i) + k2(i - 1)) / 2
    end
    #         At(j)=A;
    #         plot(k2,k1);
    #         pause
    #     end
    pos = 1
    min = 1
    for i in mslice[1:length(k1)]:
        #k2(i)
        d = sqrt((k2(i) - 0) * (k2(i) - 0) + (k1(i) - 1) * (k1(i) - 1))
        if d < min:
            min = d
            pos = i
        end
    end
    display(mstring('minimo----------'))
    min()
    display(mstring('posicio----------'))
    pos()
    kx_ = k1(pos) 
    print (kx_)
    ky_ = k2(pos) 
    print (ky_)


end