function [sign_error,matched_error,snr, output] = binaryPAMsim(N,T_p,bit_rate,sigma,supress_plots, input)    
    %%generate random binary message: comment out if using argument
    if input==0
        x_n = 2*((rand(1,N)>0.5)-0.5);
    else 
        x_n = input;
    end
    
    % Uncomment to plot DT binary message 
    % figure() 
    % stem(x_n)
    % title("binary message x_n")
    
    %%create pulse shape:
    alpha = 0.35;  % roll-off factor

    T_s = 1/bit_rate; 
    dt = T_p/100; % sample period
    t = 0:dt:T_s*N;
    
    % pulse shape
    t_ = -10*T_s:dt:10*T_s;
    
    % Compute the root raised cosine pulse
    p = (1-alpha)*sinc(t_/T_s) + alpha*sinc(t_/T_s).*cos(pi*alpha*t_/T_s)./(1-(2*alpha*t_/T_s).^2);
    % Normalize the pulse energy to one
    p = p./sqrt(sum(abs(p).^2));
    
    if (supress_plots==0)
        figure()
        subplot(2,1,1)
        plot(t_,p)
        title("pulse shape p")
        xlabel("time (seconds)")
        ylabel("amplitude")
        subplot(2,1,2)
        plot(abs(fft(p)))
        title("spectrum P(jw)")
        xlabel("frequency (w)")
    end
    
    %%create transmitted signal:
    bits_idx = 0.5*T_s:T_s:(T_s*N-0.5*T_s);
    bits_idx = cast(bits_idx/dt,"uint32");
    
    y = 0*t;
    for i = 1:N
        y(bits_idx(i)) = x_n(i);
    end
    
    if (supress_plots==0)
        figure()
        subplot(2,1,1)
        plot(t,y)
        title("continous time binary message x(t), bit rate = " + bit_rate)
        xlabel("time (seconds)")
        ylabel("amplitude")
        subplot(2,1,2)
    end
    y = conv(y,p,'same');
    if (supress_plots==0)
        plot(t,y)
        title("transmitted signal y(t)")
        xlabel("time (seconds)")
        ylabel("amplitude")
    end
    
    %%generate the received signal (add noise):
    noise = sigma*randn(1,length(y));
    r = y + noise;
    snr = signalToNoise(y,noise,dt);
    
    if (supress_plots==0)
        figure()
        plot(t,r)
        title("Noisy received signal r(t), bit rate = " + bit_rate ...
            + ", noise \sigma = " + sigma + ", SNR = " + snr)
        xlabel("time (seconds)")
        ylabel("amplitude")
    end

    %%sign-based receiver:
    x_hat = zeros(1,N);
    x_hat_ct = zeros(1,length(r));
    
    for i = 1:N
        x_hat(i) = sign(r(bits_idx(i)));
        x_hat_ct(bits_idx(i)) = sign(r(bits_idx(i)));
    end
    
    % Uncomment to plot CT r(t) and x_hat
    % figure()
    % subplot(2,1,1)
    % plot(t,r)
    % hold on
    % plot(t,x_hat_ct)
    % title("sign-based receiver")
    % legend("reeived signal r(t)","x_hat (CT)")
    % xlabel("time (seconds)")
    % ylabel("amplitude")
    
    sign_error = sum(x_hat ~= x_n) / N;
    
    if (supress_plots==0)
        figure()
        subplot(2,1,1)
        stem(x_n)
        title("Sign-Based Receiver, bit rate = " + bit_rate + ...
            ", error rate = " + sign_error)
        subtitle("sent message x[n]")
        subplot(2,1,2)
        stem(x_hat)
        subtitle("decoded message x_{hat}[n]")
        xlabel("n")
    end

    %%matched filter receiver:
    x_matched = zeros(1,N);
    x_matched_ct = zeros(1,length(r));
    
    for i = 1:N
        tim = bits_idx(i);
        z = conv(r,p,'same');
        x_matched(i) = sign(z(tim));
        x_matched_ct(tim) = sign(z(tim));
    end

    output = x_matched;
    
    % Uncomment to plot CT r(t) and x_hat
    % figure()
    % plot(t,r)
    % hold on
    % plot(t,x_matched_ct)
    % title("matched filter receiver")
    % legend("received signal r(t)","matched filter result (CT)")
    
    matched_error = sum(x_matched ~= x_n) / N;
    
    if (supress_plots==0)
        figure()
        subplot(2,1,1)
        stem(x_n)
        title("Matched Filter Receiver, bit rate = " + bit_rate + ...
            ", error rate = " + matched_error)
        subtitle("sent message x[n]")
        subplot(2,1,2)
        stem(x_matched)
        subtitle("decoded message x_{hat}[n]")
        xlabel("n")
    end

end

function snr = signalToNoise(signal,noise,dt)
    p_y = sum(signal.^2.*dt);
    p_n = sum(noise.^2.*dt);
    snr = p_y/p_n;
end