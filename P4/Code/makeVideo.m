function [ ] = makeVideo( Frames, path, hz )
    outputVideo = VideoWriter(path);
    outputVideo.FrameRate = hz;
    open(outputVideo);

    for i = 1:numel(Frames)
        img = Frames{i};
        writeVideo(outputVideo,img);
    end
    close(outputVideo);
end

